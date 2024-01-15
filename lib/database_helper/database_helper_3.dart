import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper3 {
  late Database _database;

  Future<void> initDatabase() async {
    //final path = join(await getDatabasesPath(), 'encryptionDb.db');
    _database = await openDatabase('encryptionDb.db', version: 1, onCreate: (db, version) {
      // Create tables for Database 3
      db.execute('''
        CREATE TABLE hiddenBooks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          encryptedData TEXT
        )
      ''').then((value){
        print('Table created');
      }).catchError((error){
        print('Error table can\'t be created  ${error.toString()}');
      });
    });
  }

  // Insert data into Database 3
  Future<void> insertData(String encryptedData,) async {
    await _database.insert('hiddenBooks', {'encryptedData': encryptedData});
  }

  // Update data in Database 3
  Future<void> updateData(int id, String encryptedData) async {
    await _database.update('hiddenBooks', {'encryptedData': encryptedData,},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFromDatabase3() async {
    List<Map<String, Object?>> data=await _database.rawQuery('SELECT * FROM hiddenBooks');
    return data;
  }

}