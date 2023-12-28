import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper2 {
  late Database _database;

  Future<void> initDatabase() async {
    //final path = join(await getDatabasesPath(), 'database2.db');
    _database = await openDatabase('database2.db', version: 1, onCreate: (db, version) {
      // Create tables for Database 2
      db.execute('''
        CREATE TABLE table2(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          value INTEGER
        )
      ''').then((value){
        print('Table created');
      }).catchError((error){
        print('Error table can\'t be created  ${error.toString()}');
      });
    });
  }

  // Insert data into Database 2
  Future<void> insertData(String name, int value) async {
    await _database.insert('table2', {'name': name, 'value': value});
  }

  // Update data in Database 2
  Future<void> updateData(int id, String name, int value) async {
    await _database.update('table2', {'name': name, 'value': value},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFromDatabase2() async {
    List<Map<String, Object?>> data=await _database.rawQuery('SELECT * FROM table2');
    return data;
  }

  // Function to exchange data from Database 1
  // Future<void> exchangeDataFromDatabase1(List<Map<String, dynamic>> dataFromDatabase1) async {
  //   for (var data in dataFromDatabase1) {
  //     insertData(data['name'], data['value']);
  //   }
  // }
}