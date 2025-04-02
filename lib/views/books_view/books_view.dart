import 'package:flutter/material.dart';
import 'package:tesArte/common/components/tesarte_search_bar.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/models/book/google_book.dart';
import 'package:tesArte/views/books_view/components/google_books_preview_dialog.dart';

class BooksView extends StatefulWidget {
  static const String route = "/books";
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  late TesArteSearchBar tesArteSearchBar;
  List<GoogleBook> booksFound = [];

  @override
  void initState() {
    tesArteSearchBar = TesArteSearchBar(
      onSearch: (value) {
      }
    );
    super.initState();
  }

  @override
  BasicLayout build(BuildContext context) {
    return BasicLayout(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text("BOOKS VIEW"),
          IconButton(
            tooltip: "Procurar en Google Books",
            icon: Icon(Icons.find_in_page),
            onPressed: () => GoogleBooksPreviewDialog.show(context),
          )
        ],
      )
    );
  }
}
