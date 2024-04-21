import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// My Packages
import 'package:cygnus/state.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductState();
  }
}

enum _StateOfProduct { nonVerified, hasProduct, noProduct }

class _ProductState extends State<Product> {
  late dynamic _staticFeed;
  late dynamic _staticReviews;

  _StateOfProduct _hasProduct = _StateOfProduct.nonVerified;
  late dynamic _product;

  List<dynamic> _reviews = [];
  bool _loadingReviews = false;
  bool _hasReviews = false;

  late PageController _controladorSlides;
  late int _slideSelecionado;

  @override
  void initState() {
    super.initState();

    __readStaticFeed();
    _iniciarSlides();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _controladorSlides = PageController(initialPage: _slideSelecionado);
  }

  Future<void> __readStaticFeed() async {
    String conteudoJson =
        await rootBundle.loadString("lib/resources/json/home.json");
    _staticFeed = await json.decode(conteudoJson);

    conteudoJson =
        await rootBundle.loadString("lib/resources/json/reviews.json");
    _staticReviews = await json.decode(conteudoJson);

    _loadProduct();
    _loadReviews();
  }

  void _loadProduct() {
    setState(() {
      _product = _staticFeed['products']
          .firstWhere((produto) => produto["_id"] == stateApp.idProduct);

      _hasProduct = _product != null
          ? _StateOfProduct.hasProduct
          : _StateOfProduct.noProduct;
    });
  }

  void _loadReviews() {
    setState(() {
      _loadingReviews = true;
    });

    var moreReviews = _staticReviews["reviews"];

    setState(() {
      _loadingReviews = false;
      _reviews = moreReviews;

      _hasReviews = _reviews.isNotEmpty;
    });
  }

// CONSERTAR AAAAAAA
  Widget _noProductMessage() {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [
                    Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text("Cygnus"))
                  ]),
                  GestureDetector(
                      onTap: () {
                        stateApp.showProduct(stateApp.idProduct);
                      },
                      child: const Icon(Icons.arrow_back))
                ])),
        body: const SizedBox.expand(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error, size: 32, color: Colors.red),
          Text("Product unavaliable :(",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red)),
          Text("Go back to previous screen.", style: TextStyle(fontSize: 14))
        ])));
  }

// CONSERTAR AAAAAAA
  Widget _noReviewsMessage() {
    return const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.error, size: 32, color: Colors.red),
      Text("No reviews available yet.",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red))
    ]);
  }

  Widget _showReviews() {
    return _loadingReviews
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: _reviews.map((item) {
              return SizedBox(
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.account_circle_rounded,
                              size: 35,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  item["user"]["name"],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: RatingBar.builder(
                                    ignoreGestures: true,
                                    initialRating: item["rating"].toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 12,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 72, 20, 141),
                                    ),
                                    onRatingUpdate: (rating) {
                                      //
                                    },
                                  ))
                            ],
                          ),
                        ],
                      ),
                      // ----------
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            item["comment"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ])
                    ],
                  ),
                ),
              );
            }).toList(),
          );
  }

  Widget _showProduct() {
    bool usuarioLogado = stateApp.user != null;

    String productId = _product["_id"].toString();

    String imagePath = "lib/resources/img/product$productId.jpeg";

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          stateApp.showMain();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        stateApp.showMain();
                      },
                      child: const Icon(Icons.arrow_back, size: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Voltar".toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, left: 15),
                          child: Image.asset(
                            "lib/resources/icons/cygnus.png",
                            height: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            body: Scrollbar(
                child: SingleChildScrollView(
              child: SizedBox(
                  // width: 2000,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Ensure that the row items are aligned to the start
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Expanded(
                              // Ensure that the column occupies the remaining space
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 157),
                                child: Text(
                                  _product["product"]["name"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _product["company"]["name"],
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: RatingBar.builder(
                                  ignoreGestures: true,
                                  initialRating: _product["rating"].toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 16,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 72, 20, 141),
                                  ),
                                  onRatingUpdate: (rating) {
                                    //
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "R\$ ${_product["product"]["price"].toString()}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ]),
                  // ------------------------
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Text(
                            _product["product"]["description"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // -----------------
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 30),
                    child: Column(children: [
                      Card(
                        margin: const EdgeInsets.all(10),
                        child: OverflowBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton(
                              child: const Text(
                                'Get Cygnus Pass',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 184, 54, 244),
                        margin: const EdgeInsets.all(10),
                        child: OverflowBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton(
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  // -----------------------------
                  const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 20),
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )),
                  SizedBox(
                    height: 230,
                    child: PageView.builder(
                      itemCount: 3,
                      controller: _controladorSlides,
                      onPageChanged: (slide) {
                        setState(() {
                          _slideSelecionado = slide;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        return Image.asset(
                          "lib/resources/img/gallery.jpg",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PageViewDotIndicator(
                      currentItem: _slideSelecionado,
                      count: 3,
                      unselectedColor: Colors.black26,
                      selectedColor: const Color.fromARGB(255, 159, 33, 243),
                      duration: const Duration(milliseconds: 200),
                      boxShape: BoxShape.circle,
                    ),
                  ),
                  // -------
                  const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 20),
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      )),
                  // ------
                  _hasReviews ? _showReviews() : _noReviewsMessage(),
                ],
              )),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Widget Product = const SizedBox.shrink();

    if (_hasProduct == _StateOfProduct.nonVerified) {
      Product = const SizedBox();
    } else if (_hasProduct == _StateOfProduct.hasProduct) {
      Product = _showProduct();
    } else {
      Product = _noProductMessage();
    }

    return Product;
  }
}
