
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tow_local_database/cubit/library_state.dart';
import 'package:tow_local_database/models/book_model.dart';
import 'package:tow_local_database/models/hidden_book_model.dart';

import '../database_helper/Database_helper_1.dart';
import '../database_helper/database_helper_2.dart';
import '../database_helper/database_helper_3.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitial());
  final DatabaseHelper1 databaseHelper1 = DatabaseHelper1();
  final DatabaseHelper2 databaseHelper2 = DatabaseHelper2();
  final DatabaseHelper3 databaseHelper3 = DatabaseHelper3();

  Widget targetWidget=Image.asset('assets/images/hide_box.png',scale: 2.7,);
  static LibraryCubit get(context) => BlocProvider.of(context);

//////insert to books in databaseHelper1
// for(int i=1;i<=8;i++)
// {
//   databaseHelper1.insertData('book($i)', 'assets/images/books/book($i).png');
// }


  List<BookModel> books=[];
  List<BookModel> readingList=[];
  bool isVisible=false;

  getBooksData() async {
    //emit(GetBooksDataLoadingState());
    books=[];
    var booksData = await databaseHelper1.getFromDatabase1();
  booksData.forEach((element) {
  books.add(BookModel.fromJson(element));
  });
  emit(GetBooksDataState());
  }

  getReadingListData() async {
    readingList=[];
    var booksData = await databaseHelper2.getFromDatabase2();
  booksData.forEach((element) {
    readingList.add(BookModel.fromJson(element));
  });
  emit(GetReadingListDataState());
  }

  List<dynamic> hiddenList=[];

  getHiddenListData() async {
    hiddenList=[];
    var booksData = await databaseHelper3.getFromDatabase3();
  booksData.forEach((element) {
    hiddenList.add(HiddenBookModel.fromJson(element));
  });
  emit(GetHiddenListDataState());
  }

  List<String> covers=[
    'assets/images/books/book(1).png',
    'assets/images/books/book(2).png',
    'assets/images/books/book(3).png',
    'assets/images/books/book(4).png',
    'assets/images/books/book(5).png',
    'assets/images/books/book(6).png',
    'assets/images/books/book(7).png',
    'assets/images/books/book(8).png',
    //'assets/images/books/book.png',
  ];
  var random=Random();
  addBook({required String name,String? cover}) async {
    int randomIndex = random.nextInt(covers.length);
    databaseHelper1.insertData(name, cover??covers[randomIndex]);
    await getBooksData();
    emit(AddBookState());
  }

  addBookToReadingList({required String name,required String cover}) async {
    databaseHelper2.insertData(name, cover);
    emit(AddBookToReadingListState());
  }
  addBookToHiddenList({required String encryptedData,required String key}) async {
    databaseHelper3.insertData(encryptedData,key);
    emit(AddBookToHiddenListState());
  }

  deleteBook(id)
  async {
    databaseHelper1.deleteSpecificData(id);
    //await getBooksData();
    books.removeWhere((element) => element.id==id);
    emit(DeleteBookState());
  }
  deleteBookFromReadingList(id)
  async {
    databaseHelper2.deleteSpecificData(id);
    //await getBooksData();
    readingList.removeWhere((element) => element.id==id);
    emit(DeleteBookState());
  }

  changeTargetWidgetState(newWidget){
    targetWidget=newWidget;
    emit(state);
  }

  encryptData(data)
  {
    String base64Key = generateKey(32); // Your generated base64 key
    var keyBytes = base64Decode(base64Key); // Convert to byte array

    final key = encrypt.Key(keyBytes); // Create an encryption key
    final iv = encrypt.IV.fromLength(16); // Initialization vector
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc)); // Example with AES in CBC mode
    final encrypted = encrypter.encrypt(data, iv: iv);
    print('encryptedddddddddddddddddddddd ${encrypted}');
    print('encryptedddddddddddddddddddddd22222222222 ${encrypted.base64}');
    //print('encryptedddddddddddddddddddddd2222222222233333333333 ${encrypter.decrypt(encrypt.Encrypted(base64.decode(encrypted.base64)), iv: iv)}');

    return {"data":encrypted.base64.toString(),"key":key.base64};
  }

  String generateKey(int length) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  decryptData()
  {

    //print('encryptedddddddddddddddddddddd2222222222233333333333 ${encrypter.decrypt(encrypt.Encrypted(base64.decode(encrypted)), iv: iv)}');
    hiddenList.forEach((element) {
      encrypt.Key retrievedKeyString= encrypt.Key.fromBase64(element.key);
      final iv = encrypt.IV.fromLength(16); // Initialization vector
      final encrypter = encrypt.Encrypter(encrypt.AES(retrievedKeyString, mode: encrypt.AESMode.cbc));
      hiddenList[hiddenList.indexOf(element)]=BookModel.fromJson(jsonDecode(encrypter.decrypt(encrypt.Encrypted(base64.decode(element.encryptedData!)), iv: iv)));
      emit(state);
    });

  }
}
