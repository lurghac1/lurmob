import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;

class Utils {
  var hexSymbols = [
    1,
    2,
    3,
    4,
    5,
    5,
    6,
    7,
    8,
    9,
    0,
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];

  // var list = "1234567890abcdefABCDEF";

  // final random = new Random();
  // var element = hexSymbols[1];
  // var i = _random.nextInt(hexSymbols.length);

  // static String generateAuthToken() {

  // static var auth_token = () {
  //   var list = "1234567890abcdefABCDEF";
  //   return String.fromCharCodes(Iterable.generate(
  //       32, (_) => list.codeUnitAt(new Random().nextInt(list.length))));
  // };

  static generateRandomAuthToken() {
    var list = "1234567890ABCDEF";
    return String.fromCharCodes(Iterable.generate(
        10, (_) => list.codeUnitAt(new Random().nextInt(list.length))));
  }

  static String getCryptedAuthToken() {
    var crypt_key = 'Iy952e3ae1KQUd8ZmOSr2SDfJZmNZQCK';
    var crypt_iv = '2xFHKB5oAXQSqwMT';
    final key = encrypt.Key.fromUtf8(crypt_key);
    final iv = encrypt.IV.fromUtf8(crypt_iv);
    // final iv = encrypt.IV.fromLength(16);
    // final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(generateRandomAuthToken(), iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print('generateRandomAuthToken() ${generateRandomAuthToken()}');
    print('encrypted ${encrypted.base64}');
    print('decrypted ${decrypted}');
    return encrypted.base64;
  }

  // static String getDecryptedAuthToken(encrypted) {
  //   var crypt_key = 'Iy952e3ae1KQUd8ZmOSr2SDfJZmNZQCK';
  //   var crypt_iv = '2xFHKB5oAXQSqwMT';
  //   final key = encrypt.Key.fromUtf8(crypt_key);
  //   final iv = encrypt.IV.fromUtf8(crypt_iv);
  //   final encrypter =
  //       encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  //   final decrypted = encrypter.decrypt(encrypted, iv: iv);
  //   return decrypted;
  // }
}

// void generateAuthToken(hexSymbols) {
//   // var element = hexSymbols[new Random().nextInt(hexSymbols.length)];
//   // print(element);
//   return List.generate(32, (index) => null)
//   // var authToken = List<dynamic>.generate(32, (i) => _random.next )
// }
