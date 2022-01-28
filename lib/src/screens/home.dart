import 'package:chucknorrisjoke/src/models/providers/providers.dart';
import 'package:chucknorrisjoke/src/screens/components/category_tile.dart';
import 'package:chucknorrisjoke/src/screens/results.dart';
import 'package:chucknorrisjoke/src/screens/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/capitalize_extention.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final _cathegories = ref.watch(cathegoryProvider);
    final _flow = ref.watch(flowProvider);

    Widget? _currentView;

    // preparing views for animated swicher and
    // different states.
    // emptyView is used both during search and
    // during data load
    _emptyView() => const SizedBox(key: ValueKey(1));
    _errorView(String e) => Container(
          key: const ValueKey(2),
          alignment: Alignment.center,
          child: Text(e),
        );
    _categoriesView(List<String> data) {
      return Padding(
        key: const ValueKey(3),
        padding: const EdgeInsets.only(left: 39, right: 39, top: 16),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 156 / 66,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return CategoryTile(
                child: Text(
                  data[index].capitalize(),
                  style: Theme.of(context).textTheme.headline3,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(
                              category: data[index].toString(),
                            )),
                  );
                },
              );
            }),
      );
    }

    // switching views on data load
    _cathegories.when(
      data: (data) {
        if (data != null) {
          _currentView = _categoriesView(data);
        } else {
          _currentView = const Text("Ouch, unknown error");
        }
      },
      error: (error, stackTrace) =>
          _currentView = _errorView("Connection Error"),
      loading: () => _currentView = _emptyView(),
    );

    // swiching views on app flow
    if (_flow == AppFlow.search) _currentView = _emptyView();

    return GestureDetector(
      // tap anywhere to leave search bar and see
      // all joke cathegories again (browse flow).
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }

        ref.read(flowProvider.state).state = AppFlow.browse;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  //header
                  height: 72,
                  child: Center(
                      child: Text("CHUCK NORRIS",
                          style: Theme.of(context).textTheme.headline1))),
              SizedBox(
                  //searchbar
                  width: 300,
                  height: 36,
                  child: SearchBar(
                    onTap: () =>
                        ref.read(flowProvider.state).state = AppFlow.search,
                    onSubmitted: (data) {
                      if (data.length >= 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Results(
                                    searchQuery: data,
                                  )),
                        );
                      }
                    },
                  )),
              SizedBox(
                // call to action
                height: 54,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(microseconds: 150),
                    child: (_flow == AppFlow.browse)
                        ? Text(
                            "Or choose category",
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        : Text(
                            "Search for a random joke",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                  ),
                ),
              ),
              Expanded(
                  // main area
                  child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _currentView,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
