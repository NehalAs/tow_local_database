import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper_2.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class DatabaseHelper1 {
  late Database _database;

  Future<void> initDatabase() async {
    //final path = join(await getDatabasesPath(), 'library.db');
    _database = await openDatabase('library.db', version: 1, onCreate: (db, version) {
      // Create tables for Database 1
      db.execute('''
        CREATE TABLE books(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          cover TEXT
        )
      ''').then((value){
        print('Table created');
      }).catchError((error){
        print('Error table can\'t be created  ${error.toString()}');
      });
    });
  }

  // Insert data into Database 1
  Future<void> insertData(String name, String cover) async {
    await _database.insert('books', {'name': name, 'cover': cover});
    final data = await getFromDatabase1();
    print(data);
  }

  // Update data in Database 1
  Future<void> updateData(int id, String name, String cover) async {
    await _database.update('books', {'name': name, 'cover': cover},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFromDatabase1() async {
    List<Map<String, Object?>> data=await _database.rawQuery('SELECT * FROM books');
    print('get data $data');
    return data;
  }

  Future<List<Map<String, dynamic>>> selectSpecificDataFromTable1(String columnName, String value) async {
    try {
      final List<Map<String, dynamic>> data = await _database.query(
        'books',
        where: '$columnName = ?',
        whereArgs: [value],
      );
      return data;
    } catch (e) {
      print('Error selecting specific data: $e');
      return [];
    }
  }

  Future<void> deleteSpecificData(int id) async {
    await _database.delete(
      'books', // Table name
      where: 'id = ?', // Use a where clause to specify which rows to delete
      whereArgs: [id], // Arguments for the where clause
    );
  }
  // Future<void> deleteDatabase() async {
  //   // Get the directory of the app.
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(documentsDirectory.path, "library.db");
  //
  //   // Delete the file
  //   File dbFile = File(path);
  //   if (await dbFile.exists()) {
  //     await dbFile.delete();
  //   }}

  // Future<List<Map<String, dynamic>>> selectSpecificDataFromTable2(String columnName, String value) async {
  //   try {
  //     final data = await _database.rawQuery('SELECT * FROM table2 WHERE $columnName = ?', [value]);
  //     return data;
  //   } catch (e) {
  //     print('Error selecting specific data: $e');
  //     return [];
  //   }
  // }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // // Function to exchange data to Database 2
  // Future<void> exchangeDataToDatabase2(DatabaseHelper2 dbHelper2) async {
  //   final dataToExchange = await _database.query('books');
  //   dbHelper2.exchangeDataFromDatabase1(dataToExchange);
  // }
}