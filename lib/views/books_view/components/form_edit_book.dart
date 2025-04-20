import 'package:flutter/material.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/form/tesarte_save_button.dart';
import 'package:tesArte/common/components/form/tesarte_text_form_field.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/models/book/book.dart';

final double spacing = 20.0;

class FormEditBook extends StatelessWidget {
  final Book book;

  FormEditBook({super.key, required this.book});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleBookController = TextEditingController();
  final TextEditingController subtitleBookController = TextEditingController();
  final TextEditingController descriptionBookController = TextEditingController();

  late final TesArteRating bookRating;

  late final TesArteSaveButton saveButton;

  void _initializeControllersValues() {
    titleBookController.text = book.title ?? "";
    subtitleBookController.text = book.subtitle ?? "";
    descriptionBookController.text = book.description ?? "";
  }

  void _initializeWidgets() {
    bookRating = TesArteRating(
      rating: book.rating,
    );

    saveButton = TesArteSaveButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          book.title = titleBookController.text;
          book.subtitle = subtitleBookController.text;
          book.description = descriptionBookController.text;
          book.rating = bookRating.rating;

          await book.update();

          if (book.errorDB) {
            TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar gardar os cambios"); // TODO: lang
          } else {
            TesArteToast.showSuccessToast(message: "Cambios gardados correctamente"); // TODO: lang
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllersValues();
    _initializeWidgets();

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          spacing: spacing,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: spacing,
              runSpacing: spacing,
              children: [
                Column(
                  spacing: spacing / 2,
                  children: [
                    book.getCoverImage(),
                    bookRating,
                  ]
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    TesArteTextFormField(
                      labelText: "Título", // TODO: lang
                      controller: titleBookController,
                      maxWidth: 650
                    ),
                    TesArteTextFormField(
                      labelText: "Subtítulo", // TODO: lang
                      controller: subtitleBookController,
                      maxWidth: 650
                    ),
                  ]
                )
              ],
            ),
            TesArteTextFormField(
              labelText: "Descripción", // TODO: lang
              textFormFieldType: TextFormFieldType.longText,
              maxLines: 10,
              controller: descriptionBookController,
            ),
            saveButton
          ]
        ),
      ),
    );
  }
}
