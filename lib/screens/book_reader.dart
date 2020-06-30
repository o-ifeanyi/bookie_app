import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class BookReader extends StatefulWidget {
  static String id = 'bookReader';
  final String url;
  final String title;
  BookReader({this.url, this.title});
  @override
  _BookReaderState createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  var book = false;
  bool isLoading = true;
  PDFDocument document;
  void reader() async {
    setState(() {
      isLoading = true;
    });
    try {
      document = await PDFDocument.fromURL(widget.url);
      book = true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    reader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: book
                  ? PDFViewer(
                      document: document,
                    )
                  : Center(
                      child: Text('Try again later'),
                    ),
            ),
    );
  }
}
