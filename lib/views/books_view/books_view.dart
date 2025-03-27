import 'package:flutter/material.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';

class BooksView extends StatefulWidget {
  static const String route = "/books";
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  BasicLayout build(BuildContext context) {
    return BasicLayout(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text("BOOKS VIEW"),
        ],
      )
    );
  }
}
