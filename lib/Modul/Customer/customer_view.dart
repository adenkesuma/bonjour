import 'package:bonjour/Modul/Customer/create_customer_view.dart';
import 'package:bonjour/Modul/Customer/edit_customer_view.dart';
import 'package:bonjour/Provider/dbcust_provider.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  TextEditingController _search = TextEditingController();

  void createCustomer () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateCustomerView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provCust = Provider.of<CustomerProvider>(context);
    // final custCtrl = Provider.of<CustomerController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(AppLocalizations.of(context)!.customer),
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
              itemCount: provCust.customerList.length,
              itemBuilder: (context, index) {
                final customer = provCust.customerList[index];
                return Card(
                  child: ListTile(
                    title: Text(customer.kodeCustomer),
                    subtitle: Text(customer.namaCustomer),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditCustomerView(customer: customer,),
                                  ),
                                );
                              }, 
                              icon: Icon(Icons.edit, color: Colors.blue,)
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                provCust.deleteCustomer(customer.kodeCustomer);
                              }, 
                              icon: Icon(Icons.delete, color: Colors.red,)
                            ),
                          ),
                        ],
                      ),
                    ),                   ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActBtn(action: () => createCustomer(), icon: Icons.add,),
    );
  }
}