import 'dart:convert';
import 'dart:developer' as developer;
import 'package:chucknorrisjoke/src/models/joke.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chuckNorrisApi = Provider<ChuckNorrisApi>((ref) {
  return ChuckNorrisApi();
});

class ChuckNorrisApi {
  final Dio _dio = Dio();
  final _apiBase = "https://api.chucknorris.io/jokes/";

  Future<List<String>?> getCategories() async {
    try {
      Response result = await _dio.get(_apiBase + "categories");
      developer.log("Success", name: "Fetching Categories");
      return (result.data as List<dynamic>).cast<String>();
    } on DioError catch (e) {
      if (e.response != null) {
        developer.log(jsonEncode(e.response),
            name: "Fetching Categories Error");
        return null;
      } else {
        developer.log(e.message, name: "Fetching Categories. Connection Error");
        return null;
      }
    }
  }

  Future<Joke?> getAJoke({required String category}) async {
    final _endpoint = _apiBase + "random?category=" + category;

    try {
      Response result = await _dio.get(_endpoint);
      developer.log("Success", name: "Getting A Joke about $category");
      return Joke.fromJson(result.data);
    } on DioError catch (e) {
      if (e.response != null) {
        developer.log(e.toString(), name: "Getting Joke Error");
        return null;
      } else {
        developer.log(e.message, name: "Getting Joke. Connection Error");
        return null;
      }
    }
  }

  Future<List<Joke>?> searchJokes({required String searchQuery}) async {
    if (searchQuery.length > 120) searchQuery.substring(0, 119);
    final _endpoint = _apiBase + "search?query=" + searchQuery;

    try {
      Response result = await _dio.get(_endpoint);
      developer.log("Success", name: "Getting Jokes Result");
      final _data = (result.data['result'] as List)
          .map((data) => Joke.fromJson(data))
          .toList();
      return _data;
    } on DioError catch (e) {
      if (e.response != null) {
        developer.log(e.toString(), name: "Getting Joke Error");
        return null;
      } else {
        developer.log(e.message, name: "Getting Joke. Connection Error");
        return null;
      }
    }
  }
}
