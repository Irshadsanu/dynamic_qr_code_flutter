import 'package:dynamic_qrcode_scanner/MainProvider.dart';
import 'package:dynamic_qrcode_scanner/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Consumer<MainProvider>(
          builder: (context,value,child) {
            return InkWell(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => qrpage(title: 'dynamic qr'),));
              },
                child: const Text("SUCCESSFULLY PUNCHED"));
          }
        ),
      ),
    );
  }
}
