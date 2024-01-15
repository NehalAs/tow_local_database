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
import 'package:encrypt/encrypt.dart' as encrypt;

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

  String generateKey(int length) {
    final Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

  @override
  Widget build(BuildContext context) {
    LibraryCubit.get(context).getBooksData();
    String base64Key = generateKey(32); // Your generated base64 key
    var keyBytes = base64Decode(base64Key); // Convert to byte array

    final key = encrypt.Key(keyBytes); // Create an encryption key
    final iv = encrypt.IV.fromLength(16); // Initialization vector
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc)); // Example with AES in CBC mode

    final encrypted = encrypter.encrypt('"name":"nn","cover":"hhh"', iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print('Encrypteddddddddddddddddddddddddddd: ${encrypted.base64}');
    print('Decrypteddddddd: $decrypted');

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
                              ShelfItem(book:libraryCubit.books[index]),
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