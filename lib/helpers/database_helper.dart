import 'package:catatan_keuangan/models/finance_model.dart';
import 'package:catatan_keuangan/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "finance.db";
  String financeTable =
      "CREATE TABLE finance (financeId INTEGER PRIMARY KEY AUTOINCREMENT, financeTitle TEXT NOT NULL, financeType TEXT NOT NULL, total TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  //Now we must create our user table into our sqlite db

  String users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT)";

  //We are done in this section

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(financeTable);

      signup(Users(
              username: "admin",
              password: "admin"))
          .whenComplete(() {
        // ok
      });
    });
  }

  //Now we create login and sign up method
  //as we create sqlite other functionality in our previous video

  //IF you didn't watch my previous videos, check part 1 and part 2

  //Login Method

  Future<bool> login(Users user) async {
    final Database db = await initDB();

    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where username = '${user.username}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  //Search Method
  Future<List<FinanceModel>> searchFinances(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db
        .rawQuery("select * from finance where financeTitle LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => FinanceModel.fromMap(e)).toList();
  }

  //CRUD Methods

  //Create Note
  Future<int> createFinance(FinanceModel note) async {
    final Database db = await initDB();
    return db.insert('finance', note.toMap());
  }

  //Get finance
  Future<List<FinanceModel>> getFinance() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('finance');
    return result.map((e) => FinanceModel.fromMap(e)).toList();
  }

  //Delete finance
  Future<int> deleteFinance(int id) async {
    final Database db = await initDB();
    return db.delete('finance', where: 'financeId = ?', whereArgs: [id]);
  }

  //Update finance
  Future<int> updateFinance(title, total, financeId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update finance set financeTitle = ?, total = ? where financeId = ?',
        [title, total, financeId]);
  }
}