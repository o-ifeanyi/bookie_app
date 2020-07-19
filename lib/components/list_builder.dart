import 'package:flutter/material.dart';
import 'package:bookie/components/book_card.dart';
import 'package:bookie/screens/details_screen.dart';

class ListBuilder extends StatelessWidget {
  ListBuilder({
    @required this.data,
    @required this.listLenght,
  });

  final dynamic data;
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
          debugPrint(e.toString());
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
      itemCount: listLenght > 10 ? 10 : listLenght,
      scrollDirection: Axis.horizontal,
    );
  }
}