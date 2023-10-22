import 'package:flutter/foundation.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:ntp/ntp.dart';

class MainProvider extends ChangeNotifier {
  MainProvider() {
    dynamicIdGenerate();
  }

  String repeatValue = "";

  void dynamicIdGenerate() {
    repeatValue = DateTime.now().millisecondsSinceEpoch.toString();
    notifyListeners();
  }

  String encrypt(String plainText) {
    final key = enc.Key.fromUtf8('XedfNNHdfgCCCCvsdFRT34567nbhHHHn');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return (encrypted.base64.toString());
  }

  String decrypt(String cipher) {
    final key = enc.Key.fromUtf8('XedfNNHdfgCCCCvsdFRT34567nbhHHHn');

    final iv = enc.IV.fromLength(16);

    final encrypter = enc.Encrypter(enc.AES(key));

    final decrypted2 = encrypter.decrypt64(cipher, iv: iv);

    return decrypted2;
  }

  Future<void> kk() async {
    DateTime currentTime = await NTP.now();
    print("Current time from NTP server:$currentTime");
  }

  Future<void> getNetWorkDateTime() async {
    print("hai");
    try {
      DateTime networkTime = await NTP.now();
      DateTime current = DateTime.now();
      print("Network Date and Time: $networkTime");
      print(" Date and Time: $current");
      print('Difference: ${current.difference(networkTime)}ms');
      notifyListeners();
    } catch (e) {
      print("Error:$e");
    }
  }

  Future<void> getnptTime() async {
    DateTime _myTime;
    DateTime _ntpTime;

    /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
    _myTime = await NTP.now();

    /// Or get NTP offset (in milliseconds) and add it yourself
    final int offset = await NTP.getNtpOffset(localTime: DateTime.now());
    _ntpTime = _myTime.add(Duration(milliseconds: offset));
    print('My time: $_myTime');
    print('NTP time: $_ntpTime');
    print('Difference: ${_myTime.difference(_ntpTime).inMilliseconds}ms');
  }
}
