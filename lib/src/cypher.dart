import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
    String keygen = _keygen();
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
