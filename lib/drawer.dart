import 'package:bonjour/Modul/Home/dashboard_view.dart';
import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/Modul/Pelunasan/pelunasan_view.dart';
import 'package:bonjour/Modul/Pembelian/pembelian_view.dart';
import 'package:bonjour/Modul/Penjualan/penjualan_view.dart';
import 'package:bonjour/Modul/Stock/stock_view.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {

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
                    image: DecorationImage(image: NetworkImage('${logoCompany}')),
                    borderRadius: BorderRadius.circular(100)
                  ),
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 20,),
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
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Get.offAll(DashboardView());
            },
          ),
          ListTile(
            leading: Icon(Icons.warehouse),
            title: Text('Stock'),
            onTap: () {
              Get.to(StockView());
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.monetization_on),
            childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            title: Text('Transaksi'),
            children: [
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('Penjualan'),
                onTap: () {
                  Get.to(PenjualanView());
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('Pembelian'),
                onTap: () {
                  Get.to(PembelianView());
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.payments),
            title: Text('Pelunasan'),
            onTap: () {
              Get.to(PelunasanView());
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.settings),
            childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            title: Text('Settings'),
            children: [
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('Setting1'),
                onTap: () {
                  // Get.to();
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('setting2'),
                onTap: () {
                  // Get.to();
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: loginCtrl.logout
          ),
        ],
      ),
    );
  }
}
