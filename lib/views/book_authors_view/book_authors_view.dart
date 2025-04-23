import 'package:flutter/material.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';

class BookAuthorsView extends StatefulWidget {
  static const String route = "/book_authors";
  const BookAuthorsView({super.key});

  @override
  State<BookAuthorsView> createState() => _BookAuthorsViewState();
}

class _BookAuthorsViewState extends State<BookAuthorsView> {
  @override
  BasicLayout build(BuildContext context) {
    return BasicLayout(
      body: Column(
        children: [
          Text("Autores dos meus libros")
        ]
      ),
    );
  }
}
