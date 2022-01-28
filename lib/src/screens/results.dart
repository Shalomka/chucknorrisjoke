import 'package:chucknorrisjoke/src/models/joke.dart';
import 'package:chucknorrisjoke/src/models/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/capitalize_extention.dart';

class Results extends ConsumerWidget {
  final String? category;
  final String? searchQuery;

  const Results({Key? key, this.category, this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    // Checking for null inputs
    if (category == null && searchQuery == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: const Center(
          child: Text('You must provide a category or a search query. Sorry.'),
        ),
      );
    }

    // Asigning corrent provider, depending if we want to search or browse
    final _joke = (category != null)
        ? ref.watch(randomJokeProvider(category!))
        : ref.watch(jokeSearchProvider(searchQuery!));

    final _headerText =
        (category != null) ? category!.capitalize() : '"' + searchQuery! + '"';

    // preparing views for the animated switcher
    Widget? _currentView;

    _errorView(String e) => _currentView = Center(
          child: Text(e),
          key: const ValueKey(1),
        );
    _loadingView() => _currentView = const SizedBox(
          key: ValueKey(2),
        );
    _jokeView(Joke? joke) => _currentView = Text(
          (joke != null) ? '"' + joke.value! + '"' : "No jokes found",
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
          key: const ValueKey(3),
        );

    // when the data arives from the future provider, the coresponding
    // view is loaded into the _currentView
    _joke.when(
        data: (data) => _jokeView(data),
        error: (e, stackTrace) => _errorView(e.toString()),
        loading: () => _loadingView());

    //results page header
    var _header = Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                ref.read(flowProvider.state).state = AppFlow.browse;
                Navigator.pop(context);
              },
              child: const SizedBox(
                  width: 24, height: 24, child: Icon(Icons.close, size: 24))),
          Text(
            "Random joke: " + _headerText,
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(
            width: 24,
          )
        ],
      ),
    );

    //results page footer
    var _footer = SizedBox(
        height: 92,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 44, left: 55, right: 55),
            child: ElevatedButton(
                child: const Text("Another Random Joke"),
                onPressed: () {
                  if (category != null) {
                    ref.refresh(randomJokeProvider(category!));
                  } else {
                    ref.refresh(jokeSearchProvider(searchQuery!));
                  }
                })));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _header,
            const Image(
                image: AssetImage('assets/images/chuck-norris 1.png'),
                width: 68,
                height: 68),
            Expanded(
                child: Container(
              alignment: Alignment.topCenter,
              width: 310,
              padding: const EdgeInsets.symmetric(vertical: 23),
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: _currentView ?? _loadingView()),
            )),
            _footer,
          ],
        ),
      ),
    );
  }
}
