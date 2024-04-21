import 'dart:convert';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
// My packages
import 'package:cygnus/autenticator.dart';
import 'package:cygnus/components/productcard.dart';
import 'package:cygnus/state.dart';

class MainFeed extends StatefulWidget {
  const MainFeed({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainFeedState();
  }
}

const int tamanhoPagina = 5;

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

      final totalMainFeedParaCarregar = _nextPage * tamanhoPagina;
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
            Padding(
                padding: const EdgeInsets.only(top: 2, left: 15),
                child: Image.asset(
                  "lib/resources/icons/cygnus.png",
                  height: 40,
                  color: Colors.white,
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 15, right: 5),
              child: TextField(
                controller: _filterController,
                onSubmitted: (description) {
                  _filter = description;

                  _updateMainFeed();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search for Games...',
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            )),
            actualUser
                // If has user
                ? GestureDetector(
                    onTap: () {
                      Autenticator.logout().then((_) {
                        setState(() {
                          stateApp.onLogout();
                        });

                        Toast.show("Disconnected.",
                            duration: Toast.lengthLong, gravity: Toast.bottom);
                      });
                    },
                    // Image tapped
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                        left: 11,
                        right: 15
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          stateApp.user?.photoUrl ??
                              "", // Use the user's photoUrl
                        ),
                        radius: 11,
                      ),
                    ),
                  )
// If hasn't user
                : IconButton(
                    onPressed: () {
                      Autenticator.login().then((user) {
                        setState(() {
                          stateApp.onLogin(user);
                        });

                        String formattedName =
                            user.name!.split(" ").sublist(0, 2).join(" ");

                        Toast.show("Connected successfully as $formattedName.",
                            duration: Toast.lengthLong, gravity: Toast.bottom);
                      });
                    },
                    icon: const Icon(Icons.account_circle_rounded))
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
