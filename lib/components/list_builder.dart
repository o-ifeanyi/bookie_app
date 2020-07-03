import 'package:flutter/material.dart';
import 'package:bookie/components/book_card.dart';
import 'package:bookie/screens/details_screen.dart';

class ListBuilder extends StatelessWidget {
  ListBuilder({
    @required this.data,
    @required this.listLenght,
  });

  final dynamic data;
  final String imagePlaceHolder = 'https://lh3.googleusercontent.com/proxy/u8TYJjSEp6IjX6HF2BqR2PmM68Zf6uG-l_DamX5vNfO-euliRz4vfeIJvHlp6CZ1B0EGCW3SXBTEyLjdu2poFM16m0Dr1rMt';
  final int listLenght;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var imageLink;
        try {
          imageLink = data['items'][index]['volumeInfo']
              ['imageLinks']['smallThumbnail'];
        } catch (e) {
          print('error with list image: $e');
          if (imageLink == null) {
            imageLink = imagePlaceHolder;
          }
        }

        return BookCard(
          imgHeight: 180,
          imgWidth: 130,
          imageLink: imageLink,
          onPressed: () {
            var displayBook = data['items'][index];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  bookToDisplay: displayBook,
                ),
              ),
            );
          },
        );
      },
      itemCount: listLenght,
      scrollDirection: Axis.horizontal,
    );
  }
}