import 'package:catatan_keuangan/global.dart';
import 'package:catatan_keuangan/helpers/database_helper.dart';
import 'package:catatan_keuangan/models/finance_model.dart';
import 'package:catatan_keuangan/pages/pemasukan/tambah_pemasukan.dart';
import 'package:catatan_keuangan/pages/pengeluaran/tambah_pengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isLoading = true;

  late DatabaseHelper handler;
  late Future<List<FinanceModel>> finance;
  final db = DatabaseHelper();

  final title = TextEditingController();
  final total = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    finance = handler.getFinance();

    handler.initDB().whenComplete(() {
      finance = getAllFinances();
    });
    super.initState();
  }

  Future<List<FinanceModel>> getAllFinances() {
    return handler.getFinance();
  }

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<FinanceModel>> searchFinance() {
    return handler.searchFinances(keyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      finance = getAllFinances();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                _refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(children: [
        //Search Field here
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: keyword,
            onChanged: (value) {
              //When we type something in textfield
              if (value.isNotEmpty) {
                setState(() {
                  finance = searchFinance();
                });
              } else {
                setState(() {
                  finance = getAllFinances();
                });
              }
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search"),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<FinanceModel>>(
            future: finance,
            builder: (BuildContext context,
                AsyncSnapshot<List<FinanceModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text("No data"));
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                final items = snapshot.data ?? <FinanceModel>[];
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        subtitle: Text(DateFormat("d-M-y")
                            .format(DateTime.parse(items[index].createdAt))),
                        title: Text("[${items[index].financeType}] ${items[index].financeTitle}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            //We call the delete method in database helper
                            db
                                .deleteFinance(items[index].financeId!)
                                .whenComplete(() {
                              //After success delete , refresh notes
                              //Done, next step is update notes
                              _refresh();
                            });
                          },
                        ),
                        onTap: () {
                          //When we click on note
                          setState(() {
                            title.text = items[index].financeTitle;
                            total.text = items[index].total.toString();
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            //Now update method
                                            db
                                                .updateFinance(
                                                    title.text,
                                                    total.text,
                                                    items[index].financeId)
                                                .whenComplete(() {
                                              //After update, note will refresh
                                              _refresh();
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Update"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    ),
                                  ],
                                  title: const Text("Update data"),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        //We need two textfield
                                        TextFormField(
                                          controller: title,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Keterangan is required";
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
                                              return "Total is required";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            label: Text("Total"),
                                          ),
                                        ),
                                      ]),
                                );
                              });
                        },
                      );
                    });
              }
            },
          ),
        ),
      ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            icon: const Icon(Icons.attach_money),
            label: const Text('Pemasukan'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TambahPemasukanPage())).then((value) {
                if (value) {
                  //This will be called
                  _refresh();
                }
              });
            },
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            icon: const Icon(Icons.money_off),
            label: const Text('Pengeluaran'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TambahPengeluaranPage())).then((value) {
                if (value) {
                  //This will be called
                  _refresh();
                }
              });
            },
          ),
        ],
      ),
      drawer: drawer,
    );
  }
}
