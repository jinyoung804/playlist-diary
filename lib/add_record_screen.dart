import 'package:flutter/material.dart';
import 'song_model.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _memoController = TextEditingController();
  String _selectedTag = '행복';
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('음악 기록 추가', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1DB954),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '곡 제목', hintText: '노래 제목을 입력하세요'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _artistController,
              decoration: const InputDecoration(labelText: '가수명', hintText: '아티스트를 입력하세요'),
            ),
            const SizedBox(height: 25),
            // 감정 태그 선택
            const Text('오늘 이 노래는 어떤 느낌인가요?', style: TextStyle(fontSize: 14, color: Colors.grey)),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedTag,
              items: ['행복', '슬픔', '설렘', '위안'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() { _selectedTag = newValue!; });
              },
            ),
            const SizedBox(height: 25),
            // 별점 선택
            const Text('별점', style: TextStyle(fontSize: 14, color: Colors.grey)),
            DropdownButton<int>(
              isExpanded: true,
              value: _rating,
              items: [1, 2, 3, 4, 5].map((int value) {
                return DropdownMenuItem<int>(value: value, child: Text('★' * value));
              }).toList(),
              onChanged: (newValue) {
                setState(() { _rating = newValue!; });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: '간단 메모',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      // ⭐ 핵심: 저장하기 버튼을 화면 맨 아래에 배치!
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_titleController.text.isEmpty || _artistController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('제목과 가수를 입력해주세요!')),
                  );
                  return;
                }
                final newRecord = SongRecord(
                  title: _titleController.text,
                  artist: _artistController.text,
                  tag: _selectedTag,
                  rating: _rating,
                  memo: _memoController.text,
                );
                Navigator.pop(context, newRecord);
              },
              child: const Text('저장하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}