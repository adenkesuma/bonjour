import 'package:bonjour/Modul/Customer/customer_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final custCtrl = Provider.of<CustomerController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Customer'),
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
              itemCount: custCtrl.dataCustomer.length,
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
                    title: Text('${custCtrl.dataCustomer[index].namaCustomer}'),
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
                    subtitle: Text('${custCtrl.dataCustomer[index].kodeCustomer}',style: TextStyle(fontSize: 15),),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}