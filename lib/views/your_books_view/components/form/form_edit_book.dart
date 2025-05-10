import 'package:flutter/material.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/form/tesarte_save_button.dart';
import 'package:tesArte/common/components/form/tesarte_text_form_field.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/tesarte_validator.dart';
import 'package:tesArte/data/tesarte_domain.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/your_books_view/components/form/book_author_selector.dart';
import 'package:tesArte/views/your_books_view/components/form/book_status_form_field.dart';

final double spacing = 20.0;

class FormEditBook extends StatefulWidget {
  final Book book;

  FormEditBook({super.key, required this.book});

  final GlobalKey<_FormEditBookState> _formKey = GlobalKey<_FormEditBookState>();

  @override
  State<FormEditBook> createState() => _FormEditBookState();

  bool get hasSavedChanges => _formKey.currentState?.formHasSavedChanges ?? false;
}

class _FormEditBookState extends State<FormEditBook> {
  bool formHasUnsavedChanges = false;
  bool formHasSavedChanges = false;

  int bookStatusValue = 0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleBookController = TextEditingController();
  final TextEditingController subtitleBookController = TextEditingController();
  final TextEditingController descriptionBookController = TextEditingController();
  final TextEditingController publishedYearBookController = TextEditingController();

  late final TesArteTextFormField titleFormField;
  late final TesArteTextFormField subtitleFormField;
  late final BookStatusFormField bookStatusFormField;
  late final TesArteTextFormField descriptionFormField;
  late final TesArteTextFormField publishedYearFormField;

  late final BookAuthorSelector bookAuthorSelector;

  late final TesArteRating bookRating;

  @override
  void initState() {
    _initializeFormFields();
    _initializeWidgets();
    bookStatusValue = widget.book.status ?? 0;
    super.initState();
  }

  void markFormWithChanges() {
    if (!formHasUnsavedChanges) setState(() => formHasUnsavedChanges = true);
  }

  void _initializeFormFields() {
    titleBookController.text = widget.book.title ?? "";
    subtitleBookController.text = widget.book.subtitle ?? "";
    descriptionBookController.text = widget.book.description ?? "";
    publishedYearBookController.text = widget.book.publishedYear?.toString() ?? "";

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

    bookStatusFormField = BookStatusFormField(
      initialSelection: widget.book.status,
      onChanged: (value) {
        bookStatusValue = value!;
        markFormWithChanges();
      }
    );

    bookAuthorSelector = BookAuthorSelector(book: widget.book);

    descriptionFormField = TesArteTextFormField(
      labelText: "Descripción", // TODO: lang
      minLines: 5,
      maxLength: TesArteDomain.dDescription,
      controller: descriptionBookController,
      onChange: (_) => markFormWithChanges(),
    );

    publishedYearFormField = TesArteTextFormField(
      labelText: "Ano de publicación", // TODO: lang
      textFormFieldType: TextFormFieldType.number,
      controller: publishedYearBookController,
      maxWidth: 150,
      onChange: (_) => markFormWithChanges(),
      validator: (value) => TesArteValidator.doValidation(
        type: TesArteValidatorType.integerNumber,
        value: value
      ),
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
      enabled: formHasUnsavedChanges,
      formHasChanges: formHasUnsavedChanges,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          widget.book.title = titleBookController.text;
          widget.book.subtitle = subtitleBookController.text;
          widget.book.description = descriptionBookController.text;
          widget.book.publishedYear = publishedYearBookController.text.isNotEmptyAndNotNull ? int.parse(publishedYearBookController.text) : null;
          
          widget.book.status = bookStatusValue;
          widget.book.rating = bookRating.rating;

          await widget.book.update();

          if (widget.book.errorDB) {
            TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar gardar os cambios"); // TODO: lang
          } else {
            setState(() {
              formHasSavedChanges = true;
              formHasUnsavedChanges = false;
            });
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    bookStatusFormField
                  ]
                )
              ],
            ),
            bookAuthorSelector,
            publishedYearFormField,
            descriptionFormField,
            getSaveButton()
          ]
        ),
      ),
    );
  }
}
