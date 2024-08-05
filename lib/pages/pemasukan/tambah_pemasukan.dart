import 'package:catatan_keuangan/global.dart';
import 'package:catatan_keuangan/helpers/database_helper.dart';
import 'package:catatan_keuangan/models/finance_model.dart';
import 'package:flutter/material.dart';

class TambahPemasukanPage extends StatefulWidget {
  const TambahPemasukanPage({super.key});

  @override
  State<TambahPemasukanPage> createState() => _TambahPemasukanPageState();
}

class _TambahPemasukanPageState extends State<TambahPemasukanPage> {
  final title = TextEditingController();
  final total = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pemasukan"),
        actions: [
          IconButton(
              onPressed: () {
                //Add Note button
                //We should not allow empty data to the database
                if (formKey.currentState!.validate()) {
                  db
                      .createFinance(FinanceModel(
                          financeTitle: title.text,
                          financeType: "Pemasukan",
                          total: total.text,
                          createdAt: DateTime.now().toIso8601String()))
                      .whenComplete(() {
                    //When this value is true
                    Navigator.of(context).pop(true);
                  });
                }
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Form(
          //I forgot to specify key
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: title,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Keterangan harus diisi";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Keterangan"),
                  ),
                ),
                TextFormField(
                  controller: total,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Total harus diisi";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    label: Text("Total Pemasukan (Rp)"),
                  ),
                ),
              ],
            ),
          )),
      drawer: drawer,
    );
  }
}