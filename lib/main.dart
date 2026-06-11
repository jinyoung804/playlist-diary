import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpotifyService {
  // ⚠️ 발급받은 키를 여기에 넣으세요
  final String clientId = 'c5424305b9724e38b6f3400792d8a8d7c5424305b9724e38b6f3400792d8a8d7';
  final String clientSecret = 'faa28ec6d9944933bd302132ebfb3398';

  String? _accessToken;

  // [1단계] 엑세스 토큰 발급받기
  Future<String> getAccessToken() async {
    // 이미 토큰이 있다면 재사용 (실제 서비스에선 만료 시간 체크 필요)
    if (_accessToken != null) return _accessToken!;

    final String secrets = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://spotify.com'),
      headers: {
        'Authorization': 'Basic $secrets',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      return _accessToken!;
    } else {
      throw Exception('스포티파이 토큰 발급 실패: ${response.body}');
    }
  }

  // [2단계] 음악 검색하기
  Future<void> searchMusic(String query) async {
    try {
      final token = await getAccessToken();

      // 검색어(query)와 검색 타입(track=곡, artist=가수 등) 지정
      final response = await http.get(
        Uri.parse('https://spotify.com'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tracks = data['tracks']['items'];

        for (var track in tracks) {
          print('곡 제목: ${track['name']}');
          print('아티스트: ${track['artists'][0]['name']}');
          print('앨범 커버 이미지: ${track['album']['images'][0]['url']}');
          print('-----------------------------------');
        }
      } else {
        print('검색 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }
}
