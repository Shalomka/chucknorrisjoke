import 'package:chucknorrisjoke/src/models/joke.dart';
import 'package:chucknorrisjoke/src/services/chuck_norris_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

enum AppFlow {
  none,
  search,
  browse,
}

final flowProvider = StateProvider<AppFlow>((ref) => AppFlow.browse);

final cathegoryProvider = FutureProvider.autoDispose<List<String>?>((ref) {
  final _api = ref.watch(chuckNorrisApi);
  return _api.getCategories();
});

final randomJokeProvider =
    FutureProvider.autoDispose.family<Joke?, String>((ref, cahegory) {
  final _api = ref.watch(chuckNorrisApi);
  return _api.getAJoke(category: cahegory);
});

final jokeSearchProvider =
    FutureProvider.autoDispose.family<Joke?, String>((ref, searchQuery) async {
  Joke? joke;
  final _api = ref.watch(chuckNorrisApi);
  final _random = Random();
  final jokeList = await _api.searchJokes(searchQuery: searchQuery);
  if (jokeList!.isNotEmpty) {
    joke = jokeList[_random.nextInt(jokeList.length)];
  } else {
    joke = null;
  }
  return joke;
});
