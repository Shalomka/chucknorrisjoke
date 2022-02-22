import 'dart:developer' as developer;
import 'package:chucknorrisjoke/src/models/joke.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chuckNorrisApi = Provider<ChuckNorrisApi>((ref) {
  return ChuckNorrisApi();
});

class ChuckNorrisApi {
  final _apiBase = 'https://api.chucknorris.io/jokes/';

  final DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
  final Options _cacheOptions = buildCacheOptions(const Duration(days: 7));
  late Dio _dio;
  final Dio _unCachedDio = Dio();

  ChuckNorrisApi() {
    _dio = Dio(BaseOptions())..interceptors.add(_dioCacheManager.interceptor);
  }

  Future<List<String>?> getCategories() async {
    try {
      Response result =
          await _dio.get(_apiBase + 'categories', options: _cacheOptions);
      developer.log("Success", name: "Fetching Categories");
      return (result.data as List<dynamic>).cast<String>();
    } on DioError catch (e) {
      if (e.response != null) {
        developer.log(e.response.toString(), name: "Fetching Categories Error");
        rethrow;
      } else {
        developer.log(e.message, name: "Fetching Categories. Connection Error");
        rethrow;
      }
    }
  }

  Future<Joke?> getAJoke({required String category}) async {
    final _endpoint = _apiBase + 'random?category=' + category;
    try {
      Response result = await _unCachedDio.get(_endpoint);
      developer.log("Success", name: "Getting A Joke about $category");
      return Joke.fromJson(result.data);
    } on DioError catch (e) {
      if (e.response != null) {
        developer.log(e.toString(), name: "Getting Joke Error");
        rethrow;
      } else {
        developer.log(e.message, name: "Getting Joke. Connection Error");
        rethrow;
      }
    }
  }

  Future<List<Joke>?> searchJokes({required String searchQuery}) async {
    final _endpoint = _apiBase + 'search?query=' + searchQuery;

    //this api is limited to 120 symbol searches
    if (searchQuery.length > 120) searchQuery.substring(0, 119);

    try {
      Response result = await _dio.get(_endpoint, options: _cacheOptions);
      final _data = (result.data['result'] as List)
          .map((data) => Joke.fromJson(data))
          .toList();
      if (null != result.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE)) {
        developer.log("Success", name: "Getting Jokes from Cache");

        // short delay for cached results to feel natural
        await Future.delayed(const Duration(milliseconds: 250), () async {});
      } else {
        developer.log("Success", name: "Getting Jokes from API");
      }
      return _data;
    } on DioError catch (e) {
      if (e.response != null) {
        developer.log(e.toString(), name: "Getting Joke Error");
        rethrow;
      } else {
        developer.log(e.message, name: "Getting Joke. Connection Error");
        rethrow;
      }
    }
  }
}
