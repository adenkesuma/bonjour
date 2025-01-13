import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:bonjour/Model/customer_model.dart';
import 'package:bonjour/Model/gudang_model.dart';
import 'package:bonjour/Model/item_model.dart';
import 'package:bonjour/Model/pemindahan_model.dart';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/Modul/Gudang/gudang_controller.dart';
import 'package:bonjour/Modul/Pemindahan/pemindahan_controller.dart';
import 'package:bonjour/Modul/Penjualan/daftar_stock.dart';
import 'package:bonjour/Modul/Stock/stock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonjour/data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditPemindahanView extends StatefulWidget {
  final Pemindahan pemindahan;

  const EditPemindahanView({Key? key, required this.pemindahan});

  @override
  State<EditPemindahanView> createState() => _EditPemindahanViewState();
}

class _EditPemindahanViewState extends State<EditPemindahanView> {
  late TextEditingController noPo;
  late TextEditingController tanggal;
  late TextEditingController namabrg;
  late TextEditingController qty;
  late TextEditingController hrg;

  DateTime selectedDate = DateTime.now();
  List<Item> listItems = [];
  Stock? selectStock;
  double jumlahcur = 0.0;
  double totalInv = 0.0;
  Item? selectEdit;
  List<Gudang> listgudang = [];
  Gudang? selectGudang;
  Gudang? gudangTujuan;

    @override
  void initState() {
    super.initState();
    noPo = TextEditingController(text: widget.pemindahan.no_po);
    tanggal = TextEditingController(
      text: DateFormat('EEE, dd MMM yyyy').format(widget.pemindahan.tanggal),
    );
    namabrg = TextEditingController(text: '');
    qty = TextEditingController(text: '');
    hrg = TextEditingController(text: '');
    fetchGudang();
    getData();
  }

  @override
  void dispose() {
    noPo.dispose();
    namabrg.dispose();
    qty.dispose();
    hrg.dispose();
    super.dispose();
  }

  void count() {
    setState(() {
      if (qty.text.isEmpty || hrg.text.isEmpty) {
        jumlahcur = 0.0;
        return;
      }
      jumlahcur = double.parse(qty.text) * double.parse(hrg.text);
    });
  }

  Future<void> getData() async {
    try {
      gudangTujuan = await Provider.of<GudangController>(context, listen: false)
          .getGudang(widget.pemindahan.gudang);
      if (!mounted) return; 

      setState(() {
        gudangTujuan = gudangTujuan;
      });

      List<Item> prevItem = [];
      for (var element in widget.pemindahan.item) {
        String kodeLokasi = element['kode lokasi'];
        Gudang namaGudang = await Provider.of<GudangController>(context, listen: false)
            .dataGudang
            .firstWhere((e) => e.kodeGudang == kodeLokasi);

        element['kode lokasi'] = namaGudang;
        prevItem.add(Item.fromJson({...element as Map<String, dynamic>}));
        element['kode lokasi'] = kodeLokasi;
      }

      if (!mounted) return; 
      setState(() {
        listItems = prevItem;
      });

      counttotal();
    } catch (e) {
      print("Error in getData: $e");
      
    }
  }

  Future<void> fetchGudang() async {
    try {
      await Provider.of<GudangController>(context, listen: false).fetchData();
      if (!mounted) return; 
      listgudang = Provider.of<GudangController>(context, listen: false).dataGudang;
    } catch (e) {
      print("Error fetching Gudang data: $e");
      
    }
  }

  Future<void> _selectStockFromDialog(BuildContext context) async {
    await Provider.of<StockController>(context, listen: false).fetchData();
    showDialog<Customer>(
      context: context,
      builder: (BuildContext context) {
        final stockList = Provider.of<StockController>(context).dataStock;
        return StockSelectDialog(
          stockList: stockList,
          onStockSelected: (selected) {
            setState(() {
              selectStock = selected;
              namabrg.text = "${selected.namaStock}";
            });
          },
        );
      },
    );
  }

  void addStock() {
    setState(() {
      if (namabrg.text.isNotEmpty &&
          qty.text.isNotEmpty &&
          hrg.text.isNotEmpty &&
          selectGudang != null) {
        Item newStock = Item(
          kodeStock: selectStock!.kodeStock,
          namaStock: selectStock!.namaStock,
          kodeLokasi: selectGudang!,
          qty: double.parse(qty.text),
          harga: double.parse(hrg.text),
          jumlah: jumlahcur,
        );
        listItems.add(newStock);
        namabrg.clear();
        qty.clear();
        hrg.clear();
        selectGudang = null;
        jumlahcur = 0.0;
      } else {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.warning,
            title: "Data belum lengkap",
            confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
          ),
        );
      }
      counttotal();
    });
  }

  void editStock() {
    setState(() {
      if (namabrg.text.isNotEmpty &&
          qty.text.isNotEmpty &&
          hrg.text.isNotEmpty &&
          selectGudang != null) {
        Item updatedStock = Item(
          kodeStock: selectStock!.kodeStock,
          namaStock: selectStock!.namaStock,
          kodeLokasi: selectGudang!,
          qty: double.parse(qty.text),
          harga: double.parse(hrg.text),
          jumlah: jumlahcur,
        );
        int index = listItems.indexWhere((element) => element == selectEdit);
        if (index != -1) {
          listItems[index] = updatedStock;
        }
        namabrg.clear();
        qty.clear();
        hrg.clear();
        jumlahcur = 0.0;
        selectGudang = null;
        selectEdit = null;
      } else {
        ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.warning,
            title: "Data belum lengkap",
            confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
          ),
        );
      }
      counttotal();
    });
  }

  void deleteButton(Item item) {
    setState(() {
      listItems.removeWhere((element) => element == item);
      counttotal();
    });
  }

  void counttotal() {
    setState(() {
      double total = 0;
      listItems.forEach((element) {
        total += element.jumlah;
      });
      totalInv = total;
    });
  }

  void editButton(Item item) async {
    selectStock = await Provider.of<StockController>(context, listen: false).getStock(item.kodeStock);
    if (!mounted) return; 

    setState(() {
      selectEdit = item;
      namabrg.text = item.namaStock;
      selectGudang = item.kodeLokasi;
      qty.text = item.qty.toInt().toString();
      hrg.text = item.harga.toInt().toString();
      jumlahcur = item.qty * item.harga;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pemindahanCtrl = Provider.of<PemindahanController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Pemindahan'),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  TextFormField(
                    controller: tanggal,
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                          tanggal.text = DateFormat('EEE, dd MMM yyyy').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: noPo,
                    decoration: InputDecoration(
                      labelText: 'No. PO',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<Gudang>(
                    value: gudangTujuan,
                    decoration: InputDecoration(
                      labelText: 'Gudang',
                      border: OutlineInputBorder(),
                    ),
                    items: listgudang.map((location) {
                      return DropdownMenuItem<Gudang>(
                        value: location,
                        child: Text("${location.namaGudang}"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        gudangTujuan = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 2,),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: namabrg,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                          onTap: () => _selectStockFromDialog(context), 
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<Gudang>(
                          value: selectGudang,
                          decoration: InputDecoration(
                            labelText: 'Gudang',
                            border: OutlineInputBorder(),
                          ),
                          items: listgudang.map((location) {
                            return DropdownMenuItem<Gudang>(
                              value: location,
                              child: Text("${location.namaGudang}"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectGudang = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: qty,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            count();
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: hrg,
                          decoration: InputDecoration(
                            labelText: 'Harga',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            count();
                          },
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${formatcurrency(jumlahcur)}'),
                          ],
                        ),
                        Divider(thickness: 2,),
                        SizedBox(height: 8),
                        selectEdit==null
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: addStock,
                              child: Text('Add'),
                            ),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: editStock,
                              child: Text('Edit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 2,),
                  SizedBox(height: 10),
                  Text("List Items"),
                  Divider(thickness: 2,),
                  listItems.length>0
                  ? ListView.builder(
                    shrinkWrap: true, 
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final item = listItems[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            item.namaStock,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${item.qty} x ${formatcurrency(item.harga)}"),
                                  Text("${item.kodeLokasi.kodeGudang}")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${formatcurrency(item.jumlah)}", style: TextStyle(color: Colors.black),),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          editButton(item);
                                        },
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                        padding: EdgeInsets.zero,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          deleteButton(item);
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ],
                          ),
                        ),
                      );
                    },
                  )
                  : Center(
                    child: Text("Item masih kosong"),
                  ),
                  SizedBox(height: 5,),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('${formatcurrency(totalInv)}',style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Divider(thickness: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (noPo.text=="") {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "No PO tidak boleh kosong",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                }
                              )
                            );
                            return;
                          }
                          if (gudangTujuan!.kodeGudang=="") {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "Gudang Tujuan tidak boleh kosong",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                }
                              )
                            );
                            return;
                          }
                          if (listItems.length==0) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.warning,
                                title: "List item belum ada",
                                confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                onConfirm: () {
                                  Get.back();
                                }
                              )
                            );
                            return;
                          }
                          if (listItems.length>0 && noPo.text!="" && gudangTujuan!.kodeGudang!="") {
                            Pemindahan pemindahan = Pemindahan(
                              no_po: noPo.text, 
                              gudang: gudangTujuan!.kodeGudang, 
                              gudangName: gudangTujuan!.namaGudang, 
                              tanggal: selectedDate, 
                              item: listItems, 
                              jumlah: totalInv, 
                              status: false,
                              docId: widget.pemindahan.docId
                            );
                            pemindahanCtrl.updatePemindahan(pemindahan, gudangTujuan!).then((value) => {
                            if (value) {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Edit Pemindahan Successful",
                                  confirmButtonColor: Color.fromARGB(255, 3, 192, 0),
                                  onConfirm: () {
                                    Get.back();
                                    Get.back();
                                  }
                                )
                              ),
                            }
                          });
                          }
                        }, 
                        icon: Icon(Icons.save, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white
                        ),
                        label: Text('Save'),
                      ),
                      SizedBox(width: 20,),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                        }, 
                        icon: Icon(Icons.cancel, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white
                        ),
                        label: Text('Cancel'),
                      ),
                      SizedBox(width: 20,),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (pemindahanCtrl.processing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
