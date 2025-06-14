import 'package:flutter/material.dart';
import 'package:tesArte/books/controllers/book_controller.dart';
import 'package:tesArte/books/views/ui_widgets/form/form_edit_book.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';

class BookEditView extends StatelessWidget {
  static const String route = "/book_edit";

  final BookController controller;
  const BookEditView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final FormEditBook form = FormEditBook(controller: controller);

    return ValueListenableBuilder<bool>(
      valueListenable: form.hasSavedChangesNotifier,
      builder: (context, hasSavedChanges, child) {
        return BasicLayout(
          titleView: controller.model.title.isEmptyOrNull ? "Nuevo libro" : "Edición do libro", // TODO: lang
          canPop: true,
          onBackButtonPressed: hasSavedChanges ? () => Navigator.of(context).pop(true) : null,
          body: form,
        );
      },
    );

  }
}
