import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tow_local_database/widgets/shelfItem.dart';

import 'cubit/library_cubit.dart';
import 'cubit/library_state.dart';

class HiddenBooksScreen extends StatelessWidget {
  const HiddenBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LibraryCubit.get(context).getHiddenListData();
    return BlocConsumer<LibraryCubit, LibraryState>(
      listener: (context, state) {},
      builder: (context, state) {
        LibraryCubit libraryCubit=LibraryCubit.get(context);
        return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: (){
            showAlertDialog(context);

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
              ConditionalBuilder(
                condition: libraryCubit.hiddenList.isEmpty,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.brown),
                  ),
                ),
                fallback: (context) => GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => ShelfItem(
                      book: libraryCubit.hiddenList[index],
                      onDragCompleted: () {  },
                  ),
                  itemCount: libraryCubit.hiddenList.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

TextEditingController passwordController = TextEditingController();
void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter your password'),
        content: TextFormField(
          controller: passwordController,
          obscureText: true,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if(passwordController.text=='123456')
                {
                  LibraryCubit.get(context).decryptData();
                }
              else{
                showDialog(context: context,
                builder: (context) {
                  return const AlertDialog(
                    backgroundColor: Colors.red,
                    title: Text('Wrong password',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                    content: Icon(Icons.error_outline_outlined,color: Colors.white,),
                  );
                },
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
