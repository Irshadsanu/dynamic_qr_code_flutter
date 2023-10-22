import 'dart:io';
import 'package:dynamic_qrcode_scanner/success_Page.dart';
import 'package:flutter/material.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'MainProvider.dart';
import 'declained_Page.dart';


class qrpage extends StatefulWidget {
  const qrpage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<qrpage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<qrpage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  DateTime? networkTime;

  @override
  void initState() {
    // TODO: implement initState
    getNetWorkDateTime();
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    controller!.resumeCamera();
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    print("Irshad");
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> getNetWorkDateTime() async {
    print("hai");
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
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 5,
                  borderLength: 15,
                  borderWidth: 10,
                  cutOutSize: scanArea),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    MainProvider mainProvider =
        Provider.of<MainProvider>(context, listen: false);

    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        String realvalue = mainProvider.decrypt(result!.code.toString());
        print("${realvalue}IRSHAD__REALVALUE");
        int microseconds = int.parse(realvalue) * 1000;
        DateTime dt = DateTime.fromMicrosecondsSinceEpoch(microseconds);
        DateTime currentDateTime = networkTime!;
        Duration timeDifference = currentDateTime.difference(dt);

        try {

          var valueList = realvalue.split('#');
          print(valueList);

          controller.pauseCamera();
          controller.resumeCamera();
          print("${timeDifference.inSeconds}IRSHAD__6456");


          /// check the code is expire duration
          bool checkbool = timeDifference.inSeconds.abs() <= 10;
          print("${timeDifference.abs()}IRSHAD__123456");
          print("${checkbool}IRSHAD___CHECKBOOL");

          if (checkbool) {

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuccessPage(),
                ));

            const snackBar = SnackBar(
                backgroundColor: Colors.deepPurple,
                duration: Duration(milliseconds: 3000),
                content: Text(
                  "punched successfully using code",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(color: Colors.white),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeclainedPage(),
                ));

            const snackBar = SnackBar(
                backgroundColor: Colors.deepPurple,
                duration: Duration(milliseconds: 3000),
                content: Text(
                  "Code is expired",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(color: Colors.white),
                ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

          }
        } catch (e) {

          const snackBar = SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 3000),
              content: Text(
                "Try Again",
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(color: Colors.white),
              ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          controller.pauseCamera();
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
