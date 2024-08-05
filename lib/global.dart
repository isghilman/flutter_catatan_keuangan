import 'package:catatan_keuangan/main.dart';
import 'package:catatan_keuangan/pages/home.dart';
import 'package:catatan_keuangan/pages/login.dart';
import 'package:catatan_keuangan/pages/pemasukan/pemasukan.dart';
import 'package:catatan_keuangan/pages/pengeluaran/pengeluaran.dart';
import 'package:flutter/material.dart';

Widget drawer = Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text(
          'Aplikasi Perpustakaan',
          style: TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
          Navigator.of(GlobalVariable.navState.currentState!.context).push(
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
      ),
      // ListTile(
      //   leading: const Icon(Icons.attach_money),
      //   title: const Text('Data Pemasukan'),
      //   onTap: () {
      //     Navigator.of(GlobalVariable.navState.currentState!.context).push(
      //         MaterialPageRoute(builder: (context) => const PemasukanPage()));
      //   },
      // ),
      // ListTile(
      //   leading: const Icon(Icons.money_off),
      //   title: const Text('Data Pengeluaran'),
      //   onTap: () {
      //     Navigator.of(GlobalVariable.navState.currentState!.context)
      //         .push(MaterialPageRoute(builder: (context) => const PengeluaranPage()));
      //   },
      // ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          Navigator.of(GlobalVariable.navState.currentState!.context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
        },
      ),
    ],
  ),
);
