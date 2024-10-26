
import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Login/splash_view.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => StockController()),
        ChangeNotifierProvider(create: (context) => GudangController()),
        ChangeNotifierProvider(create: (context) => CustomerController()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
