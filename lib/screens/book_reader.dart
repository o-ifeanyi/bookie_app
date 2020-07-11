import 'dart:typed_data';
import 'package:bookie/constants.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:progress_indicators/progress_indicators.dart';
import 'dart:io';

class BookReader extends StatefulWidget {
  final bookPath;
  BookReader({this.bookPath});
  @override
  _BookReaderState createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  EpubController _epubController;

  @override
  void initState() {
    _epubController = EpubController(
      // Future<Uint8List>
      data: loadBook(widget.bookPath),
      // or pure Uint8List
      // document: EpubReader.readBook(data),
    );
    super.initState();
  }

  Future<Uint8List> loadBook(var path) async {
    var book = File(path);
    return book.readAsBytesSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show actual chapter name
        title: EpubActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
            'Chapter ${chapterValue.chapter.Title ?? ''}',
            textAlign: TextAlign.start,
          ),
        ),
      ),
      // Show table of contents
      drawer: SafeArea(
        child: Drawer(
          child: EpubReaderTableOfContents(
            loader: GlowingProgressIndicator(
              child: Icon(Icons.book, size: 40, color: kBlueAccent),
            ),
            controller: _epubController,
          ),
        ),
      ),
      // Show epub document
      body: EpubView(
        controller: _epubController,
      ),
    );
  }
}
