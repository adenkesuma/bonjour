import 'package:bonjour/Modul/Gudang/create_gudang_view.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/data.dart';
import 'package:bonjour/drawer.dart';
import 'package:bonjour/floatingactbutton.dart';
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

  void createGudang () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateGudangView()),
    );
  }

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: _search,
                onChanged: (value) {},
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: gudangCtrl.dataGudang.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(31, 172, 169, 169),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      title: Text('${gudangCtrl.dataGudang[index].namaGudang}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
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
                      subtitle: Text(
                        '${gudangCtrl.dataGudang[index].kodeGudang}',
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActBtn(action: () => createGudang(), icon: Icons.add,),
    );
  }
}