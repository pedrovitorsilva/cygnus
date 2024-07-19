import 'package:cygnus/api/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:flutter/material.dart';

// My Packages
import 'package:cygnus/state.dart';
import 'package:cygnus/components/review.dart';
import 'package:cygnus/components/buy_buttons.dart';
import 'package:cygnus/components/product_info.dart';
import 'package:cygnus/components/product_appbar.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProductState();
  }
}

// Product State, based on request
// This state will be more realistic when backend its done
enum _StateOfProduct { nonVerified, hasProduct, noProduct }

class _ProductState extends State<Product> {
  late ServicesProduct _servicesProduct;
  late ServicesReviews _servicesReviews;

  _StateOfProduct _hasProduct = _StateOfProduct.nonVerified;
  late dynamic _product;

  List<dynamic> _reviews = [];
  bool _loadingReviews = false;
  bool _hasReviews = false;

  late PageController _slideController;
  late int _selectedSlide;

  @override
  void initState() {
    super.initState();

    _servicesProduct = ServicesProduct();
    _servicesReviews = ServicesReviews();

    _loadProduct();
    _loadReviews();
    _startSlides();
  }

  void _startSlides() {
    _selectedSlide = 0;
    _slideController = PageController(initialPage: _selectedSlide);
  }

  void _loadProduct() async {
    _servicesProduct.findProduct(stateApp.idProduct).then((product) {
      setState(() {
        _product = product;
        _hasProduct = _product != null
            ? _StateOfProduct.hasProduct
            : _StateOfProduct.noProduct;
      });
    });
  }

  void _loadReviews() async {
    setState(() {
      _loadingReviews = true;
    });

    _servicesReviews.getReviews(stateApp.idProduct).then((moreReviews) {
      setState(() {
        _loadingReviews = false;
        _reviews = moreReviews;

        _hasReviews = _reviews.isNotEmpty;
      });
    });
  }

  /// Widget appears when product is not available (backend feature to be implemented)
  Widget _noProductMessage() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: productAppBar,
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

  /// Widget appears when product hasn't reviews.
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

  /// Main widget.
  /// Contains [ProductInfo], [buttonAreas], ratingArea, Gallery and [_showReviews]
  Widget _showProduct() {
    bool usuarioLogado = stateApp.user != null;

    String productId = _product["productId"].toString();

    String imagePath = "product$productId.jpeg";

    List galleryImages = [
      "gallery.jpg",
      "gallery.jpg",
      "gallery.jpg",
    ];

    // TextController for comment input
    final TextEditingController commentController = TextEditingController();
    double userRating = _product["rating"].toDouble();

    void postComment() async {
      String comment = commentController.text.trim();

      if (comment.isNotEmpty) {
        // // Add the new review to _reviews list
        // setState(() {
        //   _reviews.add(newReview);
        //   _hasReviews = true;
        // });

        await _servicesReviews
            .addReview(stateApp.idProduct, comment, stateApp.user!, userRating)
            .then((answer) {
          _loadReviews();

          commentController.clear();
          FocusScope.of(context).unfocus(); // Close keyboard
        });
      }
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          stateApp.showMain();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: productAppBar,
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

                  // Only show Rating Area if logged
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
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
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
                                            color: Colors.yellow),
                                        onRatingUpdate: (rating) {
                                          userRating = rating;
                                        },
                                      ))),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: const InputDecoration(
                                          labelText: 'Add a comment...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Button to post comment
                                    SizedBox(
                                        width:
                                            40, // Adjust the width according to your preference
                                        height:
                                            40, // Adjust the height according to your preference
                                        child: ElevatedButton(
                                            onPressed: postComment,
                                            style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              elevation:
                                                  MaterialStateProperty.all(0),
                                            ),
                                            child: const Icon(Icons
                                                .send)) // Icon for posting comment
                                        ),
                                  ],
                                ),
                              ),
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
                          _selectedSlide = slide;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        return Image.network(
                          fileAddress(galleryImages[pagePosition]),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: PageViewDotIndicator(
                      currentItem: _selectedSlide,
                      count: galleryImages.length,
                      unselectedColor: Colors.black26,
                      selectedColor: const Color.fromARGB(255, 159, 33, 243),
                      duration: const Duration(milliseconds: 200),
                      boxShape: BoxShape.circle,
                    ),
                  ),

                  // End of Gallery

                  // Show Reviews ----------
                  _hasReviews ? _showReviews() : _noReviewsMessage(),
                ],
              )),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    Widget product = const SizedBox.shrink();

    if (_hasProduct == _StateOfProduct.nonVerified) {
      product = const SizedBox();
    } else if (_hasProduct == _StateOfProduct.hasProduct) {
      product = _showProduct();
    } else {
      product = _noProductMessage();
    }

    return product;
  }
}
