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
      // 이번엔 새로 만든 상세 화면(DetailRecordScreen)을 먼저 띄워볼게!
      home: DetailRecordScreen(),
    );
  }
}

class DetailRecordScreen extends StatelessWidget {
  DetailRecordScreen({super.key});

  // 임시로 가상의 '저장된 데이터'를 만들어 두었어. (나중에 DB에서 읽어올 데이터야)
  final Map<String, dynamic> _savedData = {
    'trackName': 'Attention',
    'artistName': 'NEWJEANS',
    'emotionTags': ['행복', '신남'],
    'rating': 4,
    'memo': '시험끝나고 들었더니 좋음',
    'createdAt': '2026.06.17', // 오늘 날짜
  };

  @override
  Widget build(BuildContext context) {
    final pointColor = Color(0xFF4CAF50); // 우리 앱의 시그니처 초록색

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        // 상단 타이틀에 저장된 날짜를 띄워주면 와이어프레임 느낌이 딱 살아!
        title: Text(
          _savedData['createdAt'],
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black), // 더보기 버튼 (수정/삭제용)
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. [곡 정보 카드 영역]
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
                      Text(_savedData['trackName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(_savedData['artistName'], style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),

            // 2. [감정 태그 섹션]
            Text('내가 느낀 감정', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: (_savedData['emotionTags'] as List<String>).map((tag) {
                // 상세 화면에서는 칩을 누르는 게 아니라 보여주기만 하니까 간단하게 Container로 만들었어.
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: pointColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: pointColor),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(color: pointColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 35),

            // 3. [별점 섹션]
            Text('별점', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < _savedData['rating'] ? Icons.star : Icons.star_border,
                  color: index < _savedData['rating'] ? pointColor : Colors.grey[300],
                  size: 30,
                );
              }),
            ),
            SizedBox(height: 35),

            // 4. [메모 섹션]
            Text('메모', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            // 입력창 대신, 와이어프레임처럼 깔끔한 사각형 박스 안에 글자를 띄워주는 구조야.
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                _savedData['memo'],
                style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}