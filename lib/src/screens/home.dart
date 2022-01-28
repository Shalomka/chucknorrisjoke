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

    // generate list of joke Cathegories
    Widget _listCathegories() {
      return _cathegories.when(
          data: (data) {
            return Padding(
              padding: const EdgeInsets.only(left: 39, right: 39, top: 16),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 156 / 66,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: data!.length,
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
          },
          error: (e, stack) => Center(
                child: Text(e.toString()),
              ),
          loading: () => const SizedBox());
    }

    return GestureDetector(
      // tap anywhere to leave search bar and see
      // all joke cathegories again (browse flow).
      onTap: () {
        ref.read(flowProvider.state).state = AppFlow.browse;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 72,
                  child: Center(
                      child: Text("CHUCK NORRIS",
                          style: Theme.of(context).textTheme.headline1))),
              SizedBox(
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
                height: 54,
                child: Center(
                  child: Text(
                    (_flow == AppFlow.browse)
                        ? "Or choose category"
                        : "Search for a random joke",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              Expanded(
                  child: Visibility(
                      visible: (_flow == AppFlow.browse) ? true : false,
                      child: _listCathegories())),
            ],
          ),
        ),
      ),
    );
  }
}
