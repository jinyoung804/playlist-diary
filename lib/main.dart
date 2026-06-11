import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  // 인증서 오류 우회 설정
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

// 반드시 main 함수와 완전히 분리된 독립된 공간에 있어야 합니다.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ItunesSearchScreen(),
    );
  }
}

class ItunesSearchScreen extends StatefulWidget {
  const ItunesSearchScreen({super.key});

  @override
  State<ItunesSearchScreen> createState() => _ItunesSearchScreenState();
}

class _ItunesSearchScreenState extends State<ItunesSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchItunes(String searchTerm) async {
    if (searchTerm.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // 윈도우 환경에서 가장 안전한 URL 생성 방식
    final url = Uri.https('://apple.com', '/search', {
      'term': searchTerm,
      'country': 'KR',
      'media': 'music',
      'entity': 'song',
      'limit': '20',
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data['results'];
        });
      } else {
        _showErrorSnackBar('데이터를 가져오지 못했습니다. (코드: ${response.statusCode})');
      }
    } catch (e) {
      _showErrorSnackBar('네트워크 오류가 발생했습니다: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iTunes 음악 검색')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: '가수 또는 노래 제목 입력',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchItunes(_controller.text),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => _searchItunes(value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                  ? const Center(child: Text('검색 결과가 없습니다.'))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final track = _searchResults[index];
                  return ListTile(
                    leading: track['artworkUrl60'] != null
                        ? Image.network(track['artworkUrl60'])
                        : const Icon(Icons.music_note),
                    title: Text(track['trackName'] ?? '알 수 없는 곡명'),
                    subtitle: Text(track['artistName'] ?? '알 수 없는 가수'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}