import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tow_local_database/cubit/library_cubit.dart';
import 'package:tow_local_database/cubit/library_state.dart';
import 'package:tow_local_database/models/book_model.dart';
import 'package:tow_local_database/reading_list_screen.dart';
import 'package:tow_local_database/widgets/shelfItem.dart';
import 'database_helper/Database_helper_1.dart';
import 'database_helper/database_helper_2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await LibraryCubit.get(context).databaseHelper1.initDatabase();
    await LibraryCubit.get(context).databaseHelper2.initDatabase();
    await LibraryCubit.get(context).databaseHelper3.initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    LibraryCubit.get(context).getBooksData();

    List<Widget> targetWidget=[];
    return BlocConsumer<LibraryCubit, LibraryState>(
      listener: (context, state) {},
      builder: (context, state) {
        LibraryCubit libraryCubit = LibraryCubit.get(context);


        // final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedString), iv: iv);
        // // Use 'decrypted' which is your original data

        return Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xff6F4E37),
              onPressed: () {
                libraryCubit.addBook(
                  name: 'book(9)',
                );
              },
              child: const Icon(Icons.add,color: Colors.white,),
              ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  //  image: DecorationImage(image:AssetImage('assets/images/ai7.png'),fit: BoxFit.cover,)
                  gradient: LinearGradient(
                      colors: [Color(0xffd6bfa7), Color(0xffF8F8FF)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                ),
              ),
              // BackdropFilter(
              //   filter: ImageFilter.blur(sigmaX: 1.7, sigmaY: 1.7),
              //   child: Container(
              //     color:
              //         Colors.black.withOpacity(0), // You can adjust the opacity
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConditionalBuilder(
                      condition: libraryCubit.books.isEmpty,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          valueColor:AlwaysStoppedAnimation( Colors.brown),
                        ),
                      ),
                      fallback: (context) =>Expanded(
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                          itemBuilder: (context, index) =>
                              ShelfItem(
                                onDragCompleted: (){
                                  LibraryCubit.get(context).addBookToReadingList(name:libraryCubit.books[index].name!,cover:libraryCubit.books[index].cover!);
                                  LibraryCubit.get(context).deleteBook(libraryCubit.books[index].id);

                                },
                                book:libraryCubit.books[index],
                              ),
                          itemCount: libraryCubit.books.length,
                        ),
                      ),
                  ),
                  DragTarget<Widget>(
                    onAccept: (receivedWidget) {
                        targetWidget.add(Expanded(child: receivedWidget));
                    },
                    builder: (context, candidateData, rejectedData) {
                      return InkWell(
                          onTap: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => const ReadingListScreen()));
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children:[Image.asset('assets/images/desk2.png'),Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Row(children:targetWidget),
                                ))],
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


}

