import 'dart:async';
import 'package:dynamic_qrcode_scanner/MainProvider.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';



class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  Timer? _timer;
  DateTime? networkTime;
  String serverTime = "";

  @override
  void initState() {

    getNetWorkDateTime();
    super.initState();

    /// Create a periodic timer for repeat
    _timer = Timer.periodic(const Duration(milliseconds: 10000), (Timer timer) {
      dynamicIdGenerate();
      getNetWorkDateTime();

      print("IRSHAD__");
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  void dynamicIdGenerate() {
    setState(() {
      MainProvider mainProvider =
          Provider.of<MainProvider>(context, listen: false);
      mainProvider.repeatValue = networkTime!.millisecondsSinceEpoch.toString();
    });
  }

  Future<void> getNetWorkDateTime() async {
    print("IRSHAD__START");

    try {
      networkTime = await NTP.now();
      DateTime current = DateTime.now();
      print("Network Date and Time: $networkTime");
      print(" Date and Time: $current");
      print('Difference: ${current.difference(networkTime!)}ms');
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("Dynamic Qr Code Scanner",style: TextStyle(color: Colors.brown)),
      ),
      body: Center(
        child: Consumer<MainProvider>(builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.zero,
            width: 172,
            height: 176,
            // color: Colors.red,
            child: QrImage(
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.white,
              data: value.encrypt(value.repeatValue),
              version: QrVersions.auto,
              size: 571,
            ),
          );
        }),
      ),
    );
  }
}
