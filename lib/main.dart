import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: AddRecordScreen(),
    );
  }
}

class AddRecordScreen extends StatefulWidget {
  AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final List<String> _availableTags = ['행복', '설렘', '신남', '위로', '우울', '잔잔한'];
  final List<String> _selectedTags = [];
  int _rating = 0;
  final TextEditingController _memoController = TextEditingController();

  final Map<String, String> _musicData = {
    'trackName': 'Attention',
    'artistName': 'NEWJEANS',
  };

  void _saveRecord() {
    final recordData = {
      'trackName': _musicData['trackName'],
      'artistName': _musicData['artistName'],
      'emotionTags': _selectedTags,
      'rating': _rating,
      'memo': _memoController.text,
      'createdAt': '2026-06-16',
    };

    print('=== 저장될 데이터 ===');
    print(recordData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('데이터가 콘솔에 출력되었습니다!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pointColor = Color(0xFF4CAF50);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text('기록 추가', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _saveRecord,
            child: Text('저장', style: TextStyle(color: pointColor, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [곡 정보 카드 영역]
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: pointColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: pointColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.music_note, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_musicData['trackName']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(_musicData['artistName']!, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // [감정 태그 섹션]
            Text('감정 태그', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: pointColor.withOpacity(0.2),
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isSelected ? pointColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide(color: isSelected ? pointColor : Colors.transparent),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),

            // [별점 섹션]
            // ◀ 여기서 ) 괄호를 닫아서 아래 위젯들이 안 씹히게 고쳤어!
            Text('별점', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? pointColor : Colors.grey[400],
                    size: 32,
                  ),
                );
              }),
            ),
            SizedBox(height: 30),

            // [메모 섹션]
            Text('메모', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _memoController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '시험끝나고 들었더니 좋음',
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: pointColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: pointColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ), // ◀ 여기에 오작동하던 여분의 괄호들을 정리했어.
          ],
        ),
      ),
    );
  }
}