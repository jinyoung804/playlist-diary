import 'package:flutter/material.dart';

//색상

const PRIMARY_COLOR = Color(0xFF1DB954);
final LIGHT_GREY_COLOR = Colors.grey[200]!;
final DARK_GREY_COLOR = Colors.grey[600]!;

//곡데이터
class Song{
  final String title;
  final String artist;
  final String mood;
  final int rating; //별점

  Song({
    required this.title,
    required this.artist,
    required this.mood,
    required this.rating,
});
}
// ── 임시 데이터 (나중에 drift DB로 교체할 부분) ─────────────────────
List<Song> songList = [
  Song(title: 'Ode to Love', artist: 'NCT WISH', mood: '행복', rating: 5),
  Song(title: 'Ode to Love', artist: 'NCT WISH', mood: '행복', rating: 5),
  Song(title: 'Ode to Love', artist: 'NCT WISH', mood: '행복', rating: 5),
  Song(title: 'Ode to Love', artist: 'NCT WISH', mood: '행복', rating: 5),
];


//기분 태그
List<String> moodTags = ['전체', '행복', '슬픔', '설렘', '위안'];

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  //현재선택된태그
  String selectedTag = '전체';

  //검색어
  String searchText = '';

  @override
  Widget build(BuildContext context){
    //검색어,태그로 리스트
    List<Song> filteredList = songList.where((song){
      bool matchTag = selectedTag == '전체' || song.mood == selectedTag;

      bool matchSearch = song.title.contains(searchText) || song.artist.contains(searchText);
      return matchTag && matchSearch;
    }).toList();

    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //상단
              Padding(padding: const EdgeInsets.fromLTRB(16,12,16,8),
              child: Text(
                '내 플레이리스트',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),

              //검색창

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                onChanged: (value){

                  setState((){
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: '기록 검색',
                  prefixIcon: Icon(Icons.search, color: DARK_GREY_COLOR),
                  filled: true,
                  fillColor: LIGHT_GREY_COLOR,
                  border: OutlineInputBorder(
                    borderRadius : BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              ),

              SizedBox(height: 12),

              //감정 태그 필터
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: moodTags.map((tag) {
                    bool isSelected = tag == selectedTag;
                    return GestureDetector(
                      onTap: () {
                        // 태그를 누르면 선택된 태그로 변경 + 화면 다시 그림
                        setState(() {
                          selectedTag = tag;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? PRIMARY_COLOR
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? PRIMARY_COLOR
                                  : DARK_GREY_COLOR,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 8),

              // ── 곡 리스트 (ListView.builder + Dismissible) ──────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final song = filteredList[index];

                    return Dismissible(
                      // 각 항목을 구분하는 고유 키
                      key: ObjectKey(song),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        // 스와이프하면 리스트에서 제거 + 화면 갱신
                        setState(() {
                          songList.remove(song);
                        });
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red[300],
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _SongCard(song: song),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ),

      // ── 곡 추가 버튼 ───────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          // TODO: 다음에 음악 검색 화면으로 이동
        },
        child: Icon(Icons.add, color: Colors.white),
      ),

      // ── 하단 네비게이션 (today_banner.dart 처럼 Container+Row) ───
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: LIGHT_GREY_COLOR)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, color: PRIMARY_COLOR),
            Icon(Icons.search, color: DARK_GREY_COLOR),
            Icon(Icons.bar_chart, color: DARK_GREY_COLOR),
          ],
        ),
      ),
    );
  }
}

// ── 곡 카드 위젯 (schedule_card.dart 패턴: Container + Row) ─────────
class _SongCard extends StatelessWidget {
  final Song song;

  const _SongCard({required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: LIGHT_GREY_COLOR, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 앨범 아트 자리 (이미지 대신 아이콘으로 표시)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: LIGHT_GREY_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.music_note, color: DARK_GREY_COLOR),
            ),

            SizedBox(width: 12),

            // 곡 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: TextStyle(color: DARK_GREY_COLOR),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      // 감정 태그
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: PRIMARY_COLOR.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          song.mood,
                          style: TextStyle(
                            fontSize: 12,
                            color: PRIMARY_COLOR,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      // 별점 (Row + Icon 반복)
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < song.rating ? Icons.star : Icons.star_border,
                            size: 14,
                            color: PRIMARY_COLOR,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
