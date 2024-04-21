import 'package:flutter/material.dart';
import 'package:cygnus/state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String productId =
        product["_id"].toString(); // Obtém o ID do produto como uma string

    String imagePath =
        "lib/resources/img/product$productId.jpeg"; // Caminho para a imagem com base no ID

    String companyAvatar = product["company"]["avatar"].toString();
    String companyPath = "lib/resources/img/$companyAvatar";

    return GestureDetector(
      onTap: () {
        stateApp.showProduct(product["_id"]);
      },
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              imagePath,
              height: 130,
            ),
            const SizedBox(
                height:
                    10), // Adiciona um espaço entre a imagem e a linha da empresa
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centraliza os elementos horizontalmente
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10), // Adiciona um espaço à direita do avatar
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 15, // Tamanho fixo do avatar
                    child: Image.asset(
                      companyPath,
                      width: 24, // Tamanho fixo do ícone da empresa
                    ),
                  ),
                ),
                Text(
                  product["company"]["name"],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
                height:
                    10), // Adiciona um espaço entre a linha da empresa e o nome do jogo
            Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centraliza os elementos horizontalmente
                children: [
                  Text(
                    product["product"]["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  )
                ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centraliza os elementos horizontalmente
              children: [
                Text(
                  "R\$ ${product['product']['price'].toString()}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                    width:
                        8), // Adiciona um espaço entre o preço e o ícone de favorito
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centraliza os elementos horizontalmente
              children: [
                // Adiciona um espaço entre o preço e o rating
                RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: product["rating"].toDouble(),
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
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(
                  top: 6, left: 15, right: 15), // Ajuste conforme necessário
              child: Card(
                color: Color.fromARGB(255, 92, 8, 228),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 2.5,
                      horizontal: 15), // Ajuste conforme necessário
                  child: Text(
                    'Click for Details',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
