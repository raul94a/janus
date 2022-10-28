import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
abstract class Janus extends Cypher {
  File? cachedFile;
  String filepath = '';
  final bool cypher;
  Janus({ this.cypher = true}) {
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
      } on Exception catch (err) {
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

abstract class Cypher {
  String key = '';
  static const String keypath = 'janusc00';
  Cypher() {
    _getKey().then((value) => key = value);
  }

  String encrypt(String string) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key)));
    final encrypted = encrypter.encrypt(string, iv: iv);
    return encrypted.base64;
  }

  String decrypt(String base64) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key)));
    String decrypted = '';
    try {
      decrypted = encrypter.decrypt64(base64, iv: iv);
      return decrypted;
    } catch (ex) {
      throw Exception(ex.toString());
    }
  }

  Future<String> _getKey() async {
    String directorypath = isMobile
        ? (await getApplicationDocumentsDirectory()).path
        : (await getApplicationSupportDirectory()).path;
    File file = File(directorypath + separator + keypath);
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    String keygen = (_keygen());
    file.writeAsStringSync(keygen);
    return keygen;
  }

  String _keygen() {
    String dic = 'abcdefghijklmnopqrstuvWXYZ0123456789';
    List<String> newDic = dic.split('')..shuffle();
    dic = newDic.join('');
    String growing = '';
    for (int i = 0; i < 32; i++) {
      growing += dic[i];
    }
    return growing;
  }

  bool get isMobile => Platform.isAndroid || Platform.isIOS;
}

class Perro extends Janus {
  Perro() : super(cypher: true);
}
class Filete extends Janus{
  Filete() : super(cypher: true);
}

abstract class FileCache {
  final File? cachedFile;
  const FileCache({required this.cachedFile});
}

main() {
  final perroA =
      Perro();
  final perroB =
      Perro();

  perroA._saveCache();
  perroB._saveCache();

  print('fadfaf');

  print(perroA.filecache);
  print(perroB.filecache);
}
