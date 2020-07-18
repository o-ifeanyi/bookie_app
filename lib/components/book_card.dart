import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            child: CachedNetworkImage(
              imageUrl: imageLink,
              fadeInDuration: Duration(seconds: 1),
              placeholder: (context, url) => GlowingProgressIndicator(
                child: Icon(
                  Icons.book,
                  size: 30,
                  color: Theme.of(context).accentColor,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error_outline),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
