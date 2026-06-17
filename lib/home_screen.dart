import 'package:flutter/material.dart';
import 'song_model.dart';
import 'add_record_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 전체 데이터 리스트
  List<SongRecord> myPlaylist = [
    SongRecord(title: 'Attention', artist: 'NewJeans', tag: '행복', rating: 5, memo: '시험 끝나고 들었더니 좋음'),
    SongRecord(title: '소나기', artist: '이클립스', tag: '슬픔', rating: 4, memo: '들을 때마다 눈물 남 ㅠㅠ'),
    SongRecord(title: 'Hype Boy', artist: 'NewJeans', tag: '설렘', rating: 5, memo: '신난다!'),
  ];

  // 1. 검색어를 저장할 변수 추가
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // 2. 검색어(한국어/영어 모두 포함)가 제목이나 가수에 들어있는지 필터링하는 로직
    List<SongRecord> filteredPlaylist = myPlaylist.where((song) {
      final titleMatch = song.title.toLowerCase().contains(searchQuery.toLowerCase());
      final artistMatch = song.artist.toLowerCase().contains(searchQuery.toLowerCase());
      final tagMatch = song.tag.contains(searchQuery); // 한국어 태그 검색도 가능!
      return titleMatch || artistMatch || tagMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 플레이리스트', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 3. 상단에 한국어 입력이 가능한 검색창 추가!
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '곡 제목, 가수, 태그(행복 등) 검색...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                // 글자가 바뀔 때마다 화면을 다시 그려서 검색 결과 반영
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 4. 리스트 뷰 영역 (filteredPlaylist를 사용하도록 변경)
          Expanded(
            child: filteredPlaylist.isEmpty
                ? const Center(child: Text('검색 결과가 없거나\n등록된 음악이 없습니다.'))
                : ListView.builder(
              itemCount: filteredPlaylist.length,
              itemBuilder: (context, index) {
                final item = filteredPlaylist[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF1DB954),
                      child: Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.artist),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(item.tag, style: TextStyle(color: Colors.green[800], fontSize: 12)),
                            ),
                            const SizedBox(width: 8),
                            Text('★' * item.rating, style: const TextStyle(color: Colors.amber, fontSize: 12)),
                          ],
                        ),
                        if (item.memo.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('📝 ${item.memo}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ]
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          // 실제 원본 리스트에서 삭제해야 하므로 대조하여 삭제
                          myPlaylist.remove(item);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1DB954),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordScreen()),
          );

          if (result != null && result is SongRecord) {
            setState(() {
              myPlaylist.add(result);
            });
          }
        },
      ),
    );
  }
}