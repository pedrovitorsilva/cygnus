import 'dart:convert';
import 'package:cygnus/components/user_message.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

// My Packages
import 'package:cygnus/autenticator.dart';
import 'package:cygnus/components/product_card.dart';
import 'package:cygnus/components/cygnus_icon.dart';
import 'package:cygnus/components/user_icon.dart';
import 'package:cygnus/components/custom_search_bar.dart';
import 'package:cygnus/state.dart';

class MainFeed extends StatefulWidget {

  /// Incial app landing page.
  /// 
  /// Main Feed with a [ProductCard] grid
  const MainFeed({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainFeedState createState() => _MainFeedState();
}

const int pageSize = 5;

class _MainFeedState extends State<MainFeed> {
  late dynamic _staticFeed;
  List<dynamic> _products = [];

  int _nextPage = 1;
  bool _loading = false;

  late TextEditingController _filterController;
  String _filter = "";

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _filterController = TextEditingController();
    _readStaticFeed();
    _recoverLoggedUser();
  }

  /// Recover user if logged on last session.
  void _recoverLoggedUser() {
    Autenticator.recoverUser().then((user) {
      if (user != null) {
        setState(() {
          stateApp.onLogin(user);
        });
      }
    });
  }

  Future<void> _readStaticFeed() async {
    final String contentJson =
        await rootBundle.loadString("lib/resources/json/home.json");

    _staticFeed = await json.decode(contentJson);

    _loadMainFeed();
  }

  void _loadMainFeed() {
    setState(() {
      _loading = true;
    });

    var feedList = [];

    if (_filter.isNotEmpty) {
      _staticFeed["products"].where((item) {
        String nome = item["product"]["name"];

        return nome.toLowerCase().contains(_filter.toLowerCase());
      }).forEach((item) {
        feedList.add(item);
      });
    } else {
      feedList = _products;

      final totalMainFeedParaCarregar = _nextPage * pageSize;
      if (_staticFeed["products"].length >= totalMainFeedParaCarregar) {
        feedList =
            _staticFeed["products"].sublist(0, totalMainFeedParaCarregar);
      }
    }

    setState(() {
      _products = feedList;
      _nextPage = _nextPage + 1;

      _loading = false;
    });
  }

  Future<void> _updateMainFeed() async {
    _products = [];
    _nextPage = 1;

    _loadMainFeed();
  }

  @override
  Widget build(BuildContext context) {
    bool actualUser = stateApp.user != null;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 27, 5, 80),
          actions: [
            /// App Main Icon ----
            const Padding(
                padding: EdgeInsets.only(top: 2, left: 15),
                child: CygnusIcon()),
            // SearchBar ----
            CustomSearchBar(
              controller: _filterController,
              onSubmitted: (description) {
                _filter = description;
                _updateMainFeed();
              },
            ),
            // UserIcon ----
            UserIcon(
              hasUser: actualUser,
              onLogout: () {
                Autenticator.logout().then((_) {
                  setState(() {
                    stateApp.onLogout();
                  });
                  userMessage("Disconnected.");
                });
              },
              onLogin: () {
                Autenticator.login().then((user) {
                  setState(() {
                    stateApp.onLogin(user);
                  });
                  userMessage(
                      "Connected successfully as ${user.formattedName}");
                });
              },
            ),
          ],
        ),
        body: FlatList(
            data: _products,
            numColumns: 2,
            loading: _loading,
            onRefresh: () {
              _filter = "";
              _filterController.clear();
              return _updateMainFeed();
            },
            onEndReached: () => _loadMainFeed(),
            buildItem: (item, int indice) {
              return SizedBox(
                  height: 320,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 7, right: 7, top: 10),
                      child: ProductCard(product: item)));
            }));
  }
}
