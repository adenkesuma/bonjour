import 'package:flutter/material.dart';

class ItemDialog extends StatelessWidget {
  final List<dynamic> items;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const ItemDialog({
    Key? key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Daftar Item'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index] as Map<String, dynamic>; // Pastikan tipe Map

            return ListTile(
              title: Text(item['nama barang'] ?? 'Tidak ada nama'), // Menampilkan nama barang
              subtitle: Text('Jumlah: ${item['jumlah barang'] ?? 0}'), // Menampilkan jumlah barang
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      onEdit(item); // Panggil fungsi edit
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      onDelete(item); // Panggil fungsi delete
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: Text('Tutup'),
        ),
      ],
    );
  }
}
