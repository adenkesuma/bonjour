import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GudangView extends StatefulWidget {
  const GudangView({super.key});

  @override
  State<GudangView> createState() => _GudangViewState();
}

class _GudangViewState extends State<GudangView> {
  TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final gudangCtrl = Provider.of<GudangController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Gudang'),
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
              itemCount: gudangCtrl.dataGudang.length,
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
                    title: Text('${gudangCtrl.dataGudang[index].namaGudang}'),
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
                    subtitle: Text('${gudangCtrl.dataGudang[index].kodeGudang}',style: TextStyle(fontSize: 15),),
                  
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