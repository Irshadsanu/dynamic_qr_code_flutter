import 'package:dynamic_qrcode_scanner/qr_scanner_screen.dart';
import 'package:flutter/material.dart';

class DeclainedPage extends StatelessWidget {
  const DeclainedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.red,
      body: Center(child: InkWell(
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => qrpage(title: 'dynamic qr'),));
        },
          child: Text("sorry you Don't access"))),
    );
  }
}
