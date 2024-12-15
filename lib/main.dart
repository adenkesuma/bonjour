import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Login/splash_view.dart';
import 'package:bonjour/Modul/Pelunasan/pelunasan_controller.dart';
import 'package:bonjour/Modul/Penjualan/pemilihan_stock.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:bonjour/Modul/Supplier/supplier_controller.dart';
import 'package:bonjour/Provider/cloud_firebase.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:bonjour/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => StockController()),
        ChangeNotifierProvider(create: (context) => GudangController()),
        ChangeNotifierProvider(create: (context) => PelunasanController()),
        ChangeNotifierProvider(create: (context) => SupplierController()),
        ChangeNotifierProvider(create: (context) => CustomerController()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => CloudFirebase()),
        ChangeNotifierProvider(create: (context) => TextControllerProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
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
      locale: Provider.of<LocaleProvider>(context).locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
