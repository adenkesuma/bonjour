import 'package:bonjour/Modul/Customer/customer_view.dart';
import 'package:bonjour/Modul/Gudang/gudang_view.dart';
import 'package:bonjour/Modul/Home/dashboard_view.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Pelunasan/pelunasan_view.dart';
import 'package:bonjour/Modul/Pembelian/pembelian_view.dart';
import 'package:bonjour/Modul/Penjualan/penjualan_view.dart';
import 'package:bonjour/Modul/Stock/stock_view.dart';
import 'package:bonjour/Modul/User/user_view.dart';
import 'package:bonjour/analytic_helper.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  MyAnalyticsHelper analytic = MyAnalyticsHelper();
  @override
  Widget build(BuildContext context) {
    final loginCtrl = Provider.of<LoginController>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('${logoCompany}')),
                      borderRadius: BorderRadius.circular(100)),
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${loginCtrl.user.username}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    Text(
                      '${loginCtrl.user.tier}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: primaryColor),
                    title: Text('Dashboard'),
                    onTap: () {
                      analytic.navigatorEvent("Dashboard");
                      Get.offAll(DashboardView());
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.menu_book, color: primaryColor),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Text('Base'),
                    children: [
                      if (loginCtrl.user.module!.contains("CUSTOMER"))
                      ListTile(
                        leading: Icon(
                          Icons.group,
                          color: primaryColor,
                        ),
                        title: Text('Customer'),
                        onTap: () {
                          analytic.navigatorEvent("Customer");
                          Get.offAll(CustomerView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("SUPPLIER"))
                      ListTile(
                        leading: Icon(
                          Icons.group,
                          color: primaryColor,
                        ),
                        title: Text('Supplier'),
                        onTap: () {
                          analytic.navigatorEvent("Supplier");
                          // Get.offAll(CustomerView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("STOCK"))
                      ListTile(
                        leading: Icon(
                          Icons.warehouse,
                          color: primaryColor,
                        ),
                        title: Text('Stock'),
                        onTap: () {
                          analytic.navigatorEvent("Stock");
                          Get.offAll(StockView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("GUDANG"))
                      ListTile(
                        leading: Icon(
                          Icons.store,
                          color: primaryColor,
                        ),
                        title: Text('Gudang'),
                        onTap: () {
                          analytic.navigatorEvent("Gudang");
                          Get.offAll(GudangView());
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.monetization_on, color: primaryColor),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Text('Transaksi'),
                    children: [
                      if (loginCtrl.user.module!.contains("PENJUALAN"))
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: primaryColor),
                        title: Text('Penjualan'),
                        onTap: () {
                          analytic.navigatorEvent("Penjualan");
                          Get.offAll(PenjualanView());
                        },
                      ),
                      if (loginCtrl.user.module!.contains("PEMBELIAN"))
                      ListTile(
                        leading: Icon(Icons.receipt_long, color: primaryColor),
                        title: Text('Pembelian'),
                        onTap: () {
                          analytic.navigatorEvent("Pembelian");
                          Get.offAll(PembelianView());
                        },
                      ),
                    ],
                  ),
                  if (loginCtrl.user.module!.contains("PELUNASAN"))
                  ListTile(
                    leading: Icon(Icons.payments, color: primaryColor),
                    title: Text('Pelunasan'),
                    onTap: () {
                      analytic.navigatorEvent("Pelunasan");
                      Get.offAll(PelunasanView());
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.settings, color: primaryColor),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    title: Text('Settings'),
                    children: [
                      if (loginCtrl.user.module!.contains("USER"))
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                        title: Text('User'),
                        onTap: () {
                          analytic.navigatorEvent("User");
                          Get.offAll(UserView());
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.receipt_long,
                          color: primaryColor,
                        ),
                        title: Text('setting2'),
                        onTap: () {
                          // Get.offAll();
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () {
                      analytic.navigatorEvent("Logout");
                      loginCtrl.logout();
                    }
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
