import 'package:flutter/material.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/books_view/components/form_edit_book.dart';

class BookEditView extends StatelessWidget {
  static const String route = "/book_edit";

  final Book book;
  const BookEditView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BasicLayout(
      titleView: book.title.isEmptyOrNull ? "Nuevo libro" : "Edición do libro", // TODO: lang
      canPop: true,
      body: FormEditBook(book: book)
    );
  }
}
