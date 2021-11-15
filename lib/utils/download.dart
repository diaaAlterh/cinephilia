import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



class Download{
  final Dio _dio = Dio();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  Download(this.flutterLocalNotificationsPlugin);
  Future<void> onSelectNotification(String? json) async {
    final obj = jsonDecode(json!);

    if (obj['isSuccess']) {
      print('hello other people${obj['filePath']}');
      OpenFile.open(obj['filePath']);

    } else {
    }
  }

  Future<void> _startDownload(
      String savePath, String fileUrl, String filename) async {
    print('_startDownload');
    print('$savePath');
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(fileUrl, savePath);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result, filename);
    }
    print('done');
  }

  Future<void> _showNotification(
      Map<String, dynamic> downloadStatus, String filename) async {
    final android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      priority: Priority.max,
      importance: Importance.max,
      playSound: true,
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? '$filename' : 'Failure',
        isSuccess
            ? 'Warning: Torrent link'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
  }

  Future<void> download(String fileName, String url) async {
    print('download method entered');
    print('$fileName');
    print('$url');

    // download
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    print('isPermissionStatusGranted');

    if (isPermissionStatusGranted) {
      print('PermissionStatusGrantedOK');

      final savePath = path.join(dir!.path, fileName);
      await _startDownload(savePath, url, fileName);
    } else {
      print('PermissionStatusGrantedNO');

      // handle the scenario when user declines the permissions
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory();
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.storage.status;

    if (status != PermissionStatus.granted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
    }

    return status == PermissionStatus.granted;
  }
}