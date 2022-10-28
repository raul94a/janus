import 'dart:convert';
import 'dart:io';

import 'package:janus/src/cypher.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

abstract class Janus extends Cypher {
  File? cachedFile;
  String filepath = '';
  final bool cypher;
  Janus({this.cypher = true}) {
    filepath = '${runtimeType.toString().toLowerCase().hashCode}_janus';
  }

  Future<void> _saveCache() async {
    String storageDirectory = (Platform.isAndroid || Platform.isIOS
            ? await path_provider.getApplicationDocumentsDirectory()
            : await path_provider.getApplicationSupportDirectory())
        .path;
    cachedFile = File(storageDirectory + separator + filepath);
  }

  Future<Map<String, dynamic>> load() async {
    if (cachedFile == null) {
      await _saveCache();
    }
    if (!cachedFile!.existsSync()) {
      cachedFile!.createSync();
      return {};
    }
    //read
    String read = cachedFile?.readAsStringSync() ?? '';
    if (read.isEmpty) return {};
    if (cypher) {
      try {
        read = decrypt(read);
      } on Exception {
        cachedFile!.deleteSync();
        read = '{}';
      }
    }
    return jsonDecode(read);
  }

  Future<void> save(Map<String, dynamic> data) async {
    if (cachedFile == null) {
      await _saveCache();
    }
    String json = jsonEncode(data);
    if (cypher) {
      json = encrypt(json);
    }

    cachedFile!.writeAsStringSync(json);
  }

  Future<void> saveCache() => _saveCache();
  String? get filecache => cachedFile?.path;
}
