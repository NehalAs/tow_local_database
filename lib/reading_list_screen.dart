import 'dart:convert';
import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tow_local_database/hidden_books_screen.dart';
import 'package:tow_local_database/widgets/shelfItem.dart';
import 'package:tow_local_database/cubit/library_cubit.dart';
import 'package:tow_local_database/cubit/library_state.dart';

class ReadingListScreen extends StatelessWidget {
  const ReadingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LibraryCubit.get(context).getReadingListData();



    return BlocConsumer<LibraryCubit, LibraryState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        LibraryCubit libraryCubit = LibraryCubit.get(context);
        return Scaffold(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConditionalBuilder(
                    condition: libraryCubit.readingList.isEmpty,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.brown),
                      ),
                    ),
                    fallback: (context) => Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) => ShelfItem(
                          book: libraryCubit.readingList[index],
                          onDragStart: (){
                            libraryCubit.changeTargetWidgetState(Image.asset('assets/images/open_hide_box.png',scale: 2.7,));
                          },
                            onDragCompleted: (){
                            Map encryptedData=libraryCubit.encryptData(jsonEncode(libraryCubit.readingList[index].toJson()));
                            libraryCubit.addBookToHiddenList(encryptedData:encryptedData['data'],key: encryptedData['key'],);
                            libraryCubit.deleteBookFromReadingList(libraryCubit.readingList[index].id);
                            }
                        ),
                        itemCount: libraryCubit.readingList.length,
                      ),
                    ),
                  ),
                  DragTarget<Widget>(
                    onAccept: (receivedWidget) {
                      libraryCubit.changeTargetWidgetState(Image.asset('assets/images/hide_box.png',scale: 2.7,));
                    },
                    // onMove: (d){
                    //
                    // },
                    builder: (context, candidateData, rejectedData) {
                      return InkWell(
                          onTap: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => const HiddenBooksScreen()));
                          },
                          child: libraryCubit.targetWidget,
                      );
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
