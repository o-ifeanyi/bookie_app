import 'dart:io';
import 'package:bookie/constants.dart';
import 'package:bookie/models/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class DownloadScreen extends StatefulWidget {
  final url;
  final bookInfo;
  static String id = 'downloadScreen';

  DownloadScreen({@required this.url, @required this.bookInfo});
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  Dio dio = Dio();
  // var downloadDB = DownloadsDB();
  String bookId;
  String downloadProgress = '0';
  int downloadedBytes = 0;
  int totalBytes = 0;

  static formatBytes(bytes, decimals) {
    if (bytes == 0) return 0.0;
    var k = 1024,
        dm = decimals <= 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        i = (log(bytes) / log(k)).floor();
    return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
  }

  void downloadBook(String link, String bookName) async {
    PermissionStatus permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      Directory appDirectory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationSupportDirectory();
      if (Platform.isAndroid) {
        Directory(appDirectory.path.split('Android')[0] + 'Bookie')
            .createSync();
      }

      String path = Platform.isIOS
          ? appDirectory.path + '/$bookName.epub'
          : appDirectory.path.split('Android')[0] + 'Bookie/$bookName.epub';
      print('path is $path');
      File file = File(path);
      if (!await file.exists()) {
        await file.create();
      } else {
        await file.delete();
        await file.create();
      }
      await dio
          .download(
            link,
            path,
            options: Options(
              followRedirects: true,
              headers: {HttpHeaders.acceptEncodingHeader: "*"},
            ),
            deleteOnError: true,
            onReceiveProgress: (received, total) async {
              if (total != -1) {
                setState(() {
                  print('received: $received, total: $total');
                  downloadedBytes = received;
                  totalBytes = total;
                  downloadProgress =
                      (received / total * 100).toStringAsFixed(0);
                });
              } else {
                Navigator.pop(context, false);
                print('Redirecting to captcha');
              }
            },
          )
          .catchError(
            (e) => {
              print('this is the error: $e'),
              Navigator.pop(context, false),
            },
          )
          .then((value) async {
            var downloadSize = formatBytes(totalBytes, 1);
            if (value != null) {
              await Provider.of<ProviderClass>(context, listen: false).addToDataBase(
                {
                  'id': bookId,
                  'path': path,
                  'size': downloadSize,
                  'bookInfo': widget.bookInfo,
                },
              );
              Navigator.pop(context, true);
            }
          });
    } else {
      permissionStatus = await Permission.storage.request();
    }
  }

  @override
  void initState() {
    super.initState();
    bookId = widget.bookInfo['volumeInfo']['title'];
    downloadBook(widget.url, widget.bookInfo['volumeInfo']['title']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: LiquidLinearProgressIndicator(
        backgroundColor: Colors.white,
        value: double.parse(downloadProgress) / 100.0,
        center: Text(
          '$downloadProgress %',
          style: TextStyle(
            color: kLightBlack,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}