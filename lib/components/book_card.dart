import 'package:bookie/constants.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:progress_indicators/progress_indicators.dart';

class BookCard extends StatelessWidget {
  final String imageLink;
  final Function onPressed;
  final double imgHeight;
  final double imgWidth;

  BookCard({this.imageLink, this.onPressed, this.imgHeight, this.imgWidth});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Container(
          height: imgHeight,
          width: imgWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: OctoImage(
              image: NetworkImage(imageLink),
              fadeInDuration: Duration(seconds: 1),
              placeholderBuilder: (context) => GlowingProgressIndicator(
                child: Icon(
                  Icons.book,
                  size: 40,
                  color: kBlueAccent,
                ),
              ),
              errorBuilder: OctoError.icon(color: Colors.red),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
