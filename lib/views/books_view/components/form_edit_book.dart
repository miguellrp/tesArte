import 'package:flutter/material.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/form/tesarte_save_button.dart';
import 'package:tesArte/common/components/form/tesarte_text_form_field.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/models/book/book.dart';

final double spacing = 20.0;

class FormEditBook extends StatefulWidget {
  final Book book;

  const FormEditBook({super.key, required this.book});

  @override
  State<FormEditBook> createState() => _FormEditBookState();
}

class _FormEditBookState extends State<FormEditBook> {
  bool formHasChanges = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleBookController = TextEditingController();
  final TextEditingController subtitleBookController = TextEditingController();
  final TextEditingController descriptionBookController = TextEditingController();

  late final TesArteTextFormField titleFormField;
  late final TesArteTextFormField subtitleFormField;
  late final TesArteTextFormField descriptionFormField;

  late final TesArteRating bookRating;

  @override
  void initState() {
    _initializeFormFields();
    _initializeWidgets();
    super.initState();
  }

  void markFormWithChanges() {
    if (!formHasChanges) setState(() => formHasChanges = true);
  }

  void _initializeFormFields() {
    titleBookController.text = widget.book.title ?? "";
    subtitleBookController.text = widget.book.subtitle ?? "";
    descriptionBookController.text = widget.book.description ?? "";

    titleFormField = TesArteTextFormField(
      labelText: "Título", // TODO: lang
      controller: titleBookController,
      maxWidth: 650,
      onChange: (_) => markFormWithChanges(),
    );

    subtitleFormField = TesArteTextFormField(
      labelText: "Subtítulo", // TODO: lang
      controller: subtitleBookController,
      maxWidth: 650,
      onChange: (_) => markFormWithChanges(),
    );

    descriptionFormField = TesArteTextFormField(
      labelText: "Descripción", // TODO: lang
      textFormFieldType: TextFormFieldType.longText,
      minLines: 5,
      controller: descriptionBookController,
      onChange: (_) => markFormWithChanges(),
    );
  }

  void _initializeWidgets() {
    bookRating = TesArteRating(
      rating: widget.book.rating,
      onChange: () => markFormWithChanges()
    );
  }

  TesArteSaveButton getSaveButton() {
    return TesArteSaveButton(
      enabled: formHasChanges,
      formHasChanges: formHasChanges,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          widget.book.title = titleBookController.text;
          widget.book.subtitle = subtitleBookController.text;
          widget.book.description = descriptionBookController.text;
          widget.book.rating = bookRating.rating;

          await widget.book.update();

          if (widget.book.errorDB) {
            TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar gardar os cambios"); // TODO: lang
          } else {
            setState(() => formHasChanges = false);
            TesArteToast.showSuccessToast(message: "Cambios gardados correctamente"); // TODO: lang
          }
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    widget.book.getCoverImage(),
                    bookRating,
                  ]
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    titleFormField,
                    subtitleFormField,
                  ]
                )
              ],
            ),
            descriptionFormField,
            getSaveButton()
          ]
        ),
      ),
    );
  }
}
