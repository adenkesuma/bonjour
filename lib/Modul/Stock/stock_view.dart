import 'package:bonjour/Modul/Stock/create_stock_view.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  TextEditingController _search = TextEditingController();

  void createStock () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateStockView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stockCtrl = Provider.of<StockController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Stock'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1
                )
              )
            ),
            padding: EdgeInsets.all(10),
            child: TextField(
                controller: _search,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stockCtrl.dataStock.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      // top: BorderSide(
                      //   color: Colors.grey,
                      //   width: 1
                      // ),
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1
                      )
                    )
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${stockCtrl.dataStock[index].namaStock}'),
                        Text('${stockCtrl.dataStock[index].kodeStock}',style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 131, 131, 131)),),
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.image),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                            
                              }, 
                              icon: Icon(Icons.edit, color: Colors.blue,)
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                            
                              }, 
                              icon: Icon(Icons.delete, color: Colors.red,)
                            ),
                          ),
                        ],
                      ),
                    ), 
                    subtitle: Text('Total Stock ${stockCtrl.dataStock[index].saldoAwal}',style: TextStyle(fontSize: 15),),
                  
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActBtn(action: () => createStock(), icon: Icons.add,),
    );
  }
}