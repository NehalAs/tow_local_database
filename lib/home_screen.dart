import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tow_local_database/cubit/library_cubit.dart';
import 'package:tow_local_database/cubit/library_state.dart';
import 'package:tow_local_database/models/book_model.dart';
import 'package:tow_local_database/reading_list_screen.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    LibraryCubit.get(context).getBooksData();
    Widget targetWidget=InkWell(
        onTap: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const ReadingListScreen()));
        },
        child: Image.asset('assets/images/desk2.png'));
    return BlocConsumer<LibraryCubit, LibraryState>(
      listener: (context, state) {},
      builder: (context, state) {
        LibraryCubit libraryCubit = LibraryCubit.get(context);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                libraryCubit.addBook(
                  name: 'book(9)',
                );
              }),
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
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, index) =>
                          shelfItem(libraryCubit.books[index]),
                      itemCount: libraryCubit.books.length,
                    ),
                  ),
                  DragTarget<Widget>(
                    onAccept: (receivedWidget) {
                      setState(() {
                        targetWidget = receivedWidget;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return targetWidget;
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

  Widget shelfItem(BookModel book) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          LongPressDraggable(
            feedback: Container(
              width: 100,
              height: 100,
              child: Image.asset(
                book.cover!,
              ),
            ),
            childWhenDragging: Container(),
            onDragCompleted: (){
              LibraryCubit.get(context).deleteBook(book.id);
              print('ssssssssssssssssssssssssssssssssssssssssssssss');
            },
            child: Image.asset(
              book.cover!,
            ),
          ),
          Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.5), // Shadow color with opacity
                    spreadRadius: 5, // Extent of the shadow in all directions
                    blurRadius: 7, // Blurring effect
                    offset: const Offset(0, 3), // Position of the shadow
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/shelf3.png',
                width: 100,
                height: 14,
              )),
        ],
      );
}


// Center(
//   child: SafeArea(
//     child: ElevatedButton(
//       onPressed: () async {
//         // final data = await databaseHelper1.getFromDatabase1();
//         // if (data.isNotEmpty) {
//         //   for (var record in data) {
//         //    // databaseHelper2.insertData(record['name'], record['value']);
//         //     print('Record ID: ${record['id']}, Name: ${record['name']}, Value: ${record['value']}');
//         //   }
//         //   var data2 =await databaseHelper2.getFromDatabase2();
//         //    print(data2);
//         // } else {
//         //   print('No data found in Database 1.');
//         // }
//         //
//         // var specificData=await databaseHelper1.selectSpecificDataFromTable1('name', 'rehaaaam');
//         // print("specificcccccccccccccc${specificData}");
//
//         // databaseHelper1.insertData('book(1)', 'assets/images/books/book(1).png');
//         //  var data1 =await databaseHelper1.getFromDatabase1();
//         //  print(data1);
//
//         // databaseHelper1.getFromDatabase1();
//
//
//       },
//       child: const Text('get data'),
//     ),
//   ),
// ),