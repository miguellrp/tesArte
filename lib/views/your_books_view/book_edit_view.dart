import 'package:flutter/material.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/your_books_view/components/form/form_edit_book.dart';

class BookEditView extends StatelessWidget {
  static const String route = "/book_edit";

  final Book book;
  const BookEditView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final FormEditBook form = FormEditBook(book: book);

    return BasicLayout(
      titleView: book.title.isEmptyOrNull ? "Nuevo libro" : "Edición do libro", // TODO: lang
      canPop: true,
      onBackButtonPressed: form.hasSavedChanges ? () => Navigator.of(context).pop(true) : null,
      body: form
    );
  }
}
