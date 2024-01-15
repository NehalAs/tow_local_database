import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        ),
                        itemCount: libraryCubit.readingList.length,
                      ),
                    ),
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
