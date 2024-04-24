import 'dart:convert';
import 'package:cygnus/components/buy_buttons.dart';
import 'package:cygnus/components/product_appbar.dart';
import 'package:cygnus/components/product_info.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// My Packages
import 'package:cygnus/state.dart';
import 'package:cygnus/components/review.dart';

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

  late PageController _slideController;
  late int _slideSelecionado;

  @override
  void initState() {
    super.initState();

    __readStaticFeed();
    _iniciarSlides();
  }

  void _iniciarSlides() {
    _slideSelecionado = 0;
    _slideController = PageController(initialPage: _slideSelecionado);
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
        resizeToAvoidBottomInset: false,
        appBar: product_appBar,
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

  Widget _noReviewsMessage() {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Text(
                "Reviews",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              )),
          Center(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 32, color: Colors.red),
                Text(
                  "No reviews available yet.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ))
        ]);
  }

  /// For each review [item], create a [Review] instance
  ///
  /// If [_loadingReviews], show a loading circle
  Widget _showReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 20),
            child: Text(
              "Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            )),
        // Data(reviews)
        _loadingReviews
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: _reviews.map((item) {
                  return Review(item: item);
                }).toList(),
              )
      ],
    );
  }

  Widget _showProduct() {
    bool usuarioLogado = stateApp.user != null;

    String productId = _product["_id"].toString();

    String imagePath = "lib/resources/img/product$productId.jpeg";

    // CHANGE THIS WHEN ADD BACKEND
    List galleryImages = [
      "lib/resources/img/gallery.jpg",
      "lib/resources/img/gallery.jpg",
      "lib/resources/img/gallery.jpg",
    ];

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          stateApp.showMain();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: product_appBar,
            body: Scrollbar(
                child: SingleChildScrollView(
              child: SizedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductInfo(product: _product, imagePath: imagePath),
                  // Only show buttonAreas if logged
                  usuarioLogado
                      ? buttonAreas
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container()),

                  // Only show Rating if logged
                  usuarioLogado
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10, bottom: 10),
                                  child: Text(
                                    "Rate this Game",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  )),
                              Center(
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10, bottom: 20),
                                      child: RatingBar.builder(
                                        initialRating:
                                            _product["rating"].toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 40,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow
                                        ),
                                        onRatingUpdate: (rating) {
                                          //
                                        },
                                      )))
                            ])
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container()),

                  // Gallery ---------------
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
                      itemCount: galleryImages.length,
                      controller: _slideController,
                      onPageChanged: (slide) {
                        setState(() {
                          _slideSelecionado = slide;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        return Image.asset(
                          galleryImages[pagePosition],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PageViewDotIndicator(
                      currentItem: _slideSelecionado,
                      count: galleryImages.length,
                      unselectedColor: Colors.black26,
                      selectedColor: const Color.fromARGB(255, 159, 33, 243),
                      duration: const Duration(milliseconds: 200),
                      boxShape: BoxShape.circle,
                    ),
                  ),
// End of Gallery

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
