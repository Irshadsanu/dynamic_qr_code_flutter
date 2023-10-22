import 'package:dynamic_qrcode_scanner/qr_Code_Screen.dart';
import 'package:dynamic_qrcode_scanner/qr_scanner_screen.dart';
import 'package:dynamic_qrcode_scanner/success_Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MainProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider(),)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const qrpage(title: 'dynamic qr'),
        home: QrCodeScreen(),
        // home: SuccessPage(),
      ),
    );
  }
}
