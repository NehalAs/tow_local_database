
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tow_local_database/cubit/library_state.dart';
import 'package:tow_local_database/models/book_model.dart';

import '../database_helper/Database_helper_1.dart';
import '../database_helper/database_helper_2.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryInitial());
  final DatabaseHelper1 databaseHelper1 = DatabaseHelper1();
  final DatabaseHelper2 databaseHelper2 = DatabaseHelper2();

  static LibraryCubit get(context) => BlocProvider.of(context);

//////insert to books in databaseHelper1
// for(int i=1;i<=8;i++)
// {
//   databaseHelper1.insertData('book($i)', 'assets/images/books/book($i).png');
// }

  List<BookModel> books=[];
  bool isVisible=false;
  getBooksData() async {
    books=[];
    var booksData = await databaseHelper1.getFromDatabase1();
  booksData.forEach((element) {
  books.add(BookModel.fromJson(element));
  });
  emit(GetBooksDataState());
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

  deleteBook(id)
  async {

    databaseHelper1.deleteSpecificData(id);
    await getBooksData();
    emit(DeleteBookState());
  }

  // changeBooksVisibilty(visible){
  //   isVisible=visible;
  //   emit(state);
  // }
}
