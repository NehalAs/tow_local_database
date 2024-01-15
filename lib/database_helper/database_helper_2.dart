import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper2 {
  late Database _database;

  Future<void> initDatabase() async {
    //final path = join(await getDatabasesPath(), 'readingList.db');
    _database = await openDatabase('readingList.db', version: 1, onCreate: (db, version) {
      // Create tables for Database 2
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
    final data = await getFromDatabase2();
    print(data);
  }

  // Update data in Database 1
  Future<void> updateData(int id, String name, String cover) async {
    await _database.update('books', {'name': name, 'cover': cover},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFromDatabase2() async {
    List<Map<String, Object?>> data=await _database.rawQuery('SELECT * FROM books');
    print('get data $data');
    return data;
  }

  Future<List<Map<String, dynamic>>> selectSpecificDataFromTable2(String columnName, String value) async {
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

}