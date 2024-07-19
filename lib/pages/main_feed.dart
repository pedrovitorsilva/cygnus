import 'package:cygnus/components/user_message.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

// My Packages
import 'package:cygnus/autenticator.dart';
import 'package:cygnus/components/product_card.dart';
import 'package:cygnus/components/cygnus_icon.dart';
import 'package:cygnus/components/user_icon.dart';
import 'package:cygnus/components/custom_search_bar.dart';
import 'package:cygnus/state.dart';
import 'package:cygnus/api/api.dart';

class MainFeed extends StatefulWidget {
  /// Incial app landing page.
  ///
  /// Main Feed with a [ProductCard] grid
  const MainFeed({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainFeedState createState() => _MainFeedState();
}

const int pageSize = 6;

class _MainFeedState extends State<MainFeed> {
  List<dynamic> _products = [];

  bool _loading = false;

  late TextEditingController _filterController;
  String _filter = "";

  late ServicesProduct _servicesProduct;
  int _lastProduct = 0;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _servicesProduct = ServicesProduct();
    _filterController = TextEditingController();
    _readFeed();
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

  void _readFeed() async {
    setState(() {
      _loading = true;
    });

    if (!(await _servicesProduct.hasMoreItemstoLoad(_lastProduct))) {
      setState(() {
        _loading = false;
      });
      return;
    }

    if (_filter.isNotEmpty) {
      _servicesProduct
          .findProducts(_lastProduct, pageSize, _filter)
          .then((products) {
        setState(() {
          _loading = false;
          _lastProduct = products.last["productId"];
          _products.addAll(products);
        });
      });
    } else {
      _servicesProduct.getProducts(_lastProduct, pageSize).then((products) {
        setState(() {
          _loading = false;
          _lastProduct = products.last["productId"];
          _products.addAll(products);
        });
      });
    }
  }

  Future<void> _updateMainFeed() async {
    _products = [];
    _lastProduct = 0;
    _readFeed();
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
            onEndReached: () => _readFeed(),
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
