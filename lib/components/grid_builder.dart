import 'package:flutter/material.dart';
import 'package:bookie/components/book_card.dart';
import 'package:bookie/screens/details_screen.dart';

class GridBuilder extends StatelessWidget {
  GridBuilder({
    @required this.data,
    @required this.lenght,
  });

  final dynamic data;
  final int lenght;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: lenght,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          var imageLink;
          String title;
          String link;
          try {
            title =
                data['items'][index]['volumeInfo']['title'] ?? 'Unavailable';
            link = data['items'][index]['accessInfo']['epub']['downloadLink'];
            imageLink = data['items'][index]['volumeInfo']['imageLinks']
                ['smallThumbnail'];
          } catch (e) {
            debugPrint(e.toString());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: BookCard(
                  imgHeight: 140,
                  imgWidth: 110,
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
                ),
              ),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Kaushan Script',
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.file_download,
                    color: link == null ? Colors.red : Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text(link != null ? 'Available' : 'Unavailable'),
                ],
              ),
            ],
          );
        });
  }
}