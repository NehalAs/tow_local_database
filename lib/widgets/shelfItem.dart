import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tow_local_database/cubit/library_cubit.dart';

import '../models/book_model.dart';

class ShelfItem extends StatelessWidget {
   ShelfItem({super.key,required this.book,this.onDragStart,required this.onDragCompleted});

   Function()? onDragStart;
   late Function() onDragCompleted;
 late var book;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if(book is BookModel)
          LongPressDraggable(
          feedback: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
             book.cover,
            ),
          ),
          childWhenDragging: Container(),
          onDragCompleted: onDragCompleted,
          onDragStarted: onDragStart,
          data: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
                book is BookModel?book.cover:'',
            ),
          ),
          child: Image.asset(
            book is BookModel?book.cover:'',
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

}
