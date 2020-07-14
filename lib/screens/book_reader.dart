import 'dart:typed_data';
import 'package:bookie/constants.dart';
import 'package:bookie/models/provider.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class BookReader extends StatefulWidget {
  final bookPath;
  final id;
  BookReader({this.bookPath, this.id});
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
    Provider.of<ProviderClass>(context, listen: false).lastOpenedBook(widget.id);
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
    // Provider.of<ProviderClass>(context, listen: false).lastOpenedBook(widget.id);
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
