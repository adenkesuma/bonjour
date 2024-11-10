import 'dart:convert';
import 'dart:io';
import 'package:bonjour/Model/stock_model.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class StockController with ChangeNotifier {
  List<Stock> dataStock = [];
  bool fetching = false;
  bool processing = false;

  List<Stock> filteredStock = [];

  Future<void> fetchData() async {
    const url = "https://api-bonjour.netlify.app/.netlify/functions/server/stocks";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List jsonData = json.decode(response.body)['stocks'];
        dataStock = jsonData.map((item) => Stock.fromJson(item)).toList();
        filteredStock = List.from(dataStock);
        notifyListeners();
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredStock = List.from(dataStock);
    } else {
      filteredStock = dataStock.where((stock) {
        return stock.namaStock.toLowerCase().contains(query.toLowerCase()) ||
            stock.kodeStock.toLowerCase().contains(query.toLowerCase()) ||
            stock.kodeJenisProduk.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<String> uploadImage(File? imageFile) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudname/upload");
    final req = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'nr2ebs90'
    ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));
    final resp = await req.send();
    if (resp.statusCode == 200) {
      final respData = await resp.stream.toBytes();
      final respString = String.fromCharCodes(respData);
      final jsondecode = json.decode(respString);
      final fulllink = Uri.parse(jsondecode['url']);
      String imgurl = '${fulllink.pathSegments[fulllink.pathSegments.length - 2]}/${fulllink.pathSegments.last}';
      return imgurl;
    }
    else {
      return "";
    }
  }

   Future<bool> addNewStock(Stock stock) async {
    final url = Uri.parse('https://api-bonjour.netlify.app/.netlify/functions/server/stocks');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(stock.toJson()),
      );
      if (response.statusCode == 201) {
        print('Stock created: ${response.body}');
        await fetchData();
        processing = false;
        notifyListeners();
        return true;
      } else {
        print('Failed to create stock: ${response.body}');
        processing = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Error: $e");
      processing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStock(String kodeStock,Stock stock) async {
    try {
      final response = await http.patch(
        Uri.parse('https://api-bonjour.netlify.app/.netlify/functions/server/stocks/$kodeStock'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(stock.toJson()),
      );

      if (response.statusCode == 200) {
        print('Stock edited: ${response.body}');
        await fetchData();
        processing = false;
        notifyListeners();
        return true;
      } else {
        print(response.body);
        processing = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('errr');
      processing = false;
      notifyListeners();
      return false;
    }
  }  

  Future<bool> deleteStock(String kodeStock) async {
    processing = true;
    notifyListeners(); 

    try {
      final response = await http.delete(Uri.parse('https://api-bonjour.netlify.app/.netlify/functions/server/stocks/${kodeStock}'));
      if (response.statusCode != 200) {
        print('Fail to delete stock');
        processing = false;
        notifyListeners();
        return false;
      } else {
        await fetchData();
        print('Delete successful');
        processing = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Error: $e");
      processing = false;
      notifyListeners();
      return false;
    }
  }



}
