import 'package:flutter/material.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/ui/ui_models/ui_book.dart';
import 'package:tesArte/book/views/ui_widgets/form/book_author_selector.dart';
import 'package:tesArte/book/views/ui_widgets/form/book_status_form_field.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/form/tesarte_save_button.dart';
import 'package:tesArte/common/components/form/tesarte_text_form_field.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/tesarte_validator.dart';
import 'package:tesArte/data/tesarte_domain.dart';


final double spacing = 20.0;

class FormEditBook extends StatefulWidget {
  final BookController controller;
  final ValueNotifier<bool> hasSavedChangesNotifier = ValueNotifier(false);

  FormEditBook({super.key, required this.controller});

  @override
  State<FormEditBook> createState() => _FormEditBookState();
}

class _FormEditBookState extends State<FormEditBook> {
  BookController get activeController => widget.controller;
  bool formHasUnsavedChanges = false;

  int bookStatusValue = 0;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<BookAuthorSelectorState> bookAuthorSelectorKey = GlobalKey<BookAuthorSelectorState>();

  final TextEditingController titleBookController = TextEditingController();
  final TextEditingController subtitleBookController = TextEditingController();
  final TextEditingController descriptionBookController = TextEditingController();
  final TextEditingController publishedYearBookController = TextEditingController();

  late final TesArteTextFormField titleFormField;
  late final TesArteTextFormField subtitleFormField;
  late final BookStatusFormField bookStatusFormField;
  late final TesArteTextFormField descriptionFormField;
  late final TesArteTextFormField publishedYearFormField;

  BookAuthorSelector? bookAuthorSelector;

  late final TesArteRating bookRating;

  @override
  void initState() {
    _initializeFormFields();
    bookStatusValue = activeController.model.status ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    titleBookController.dispose();
    subtitleBookController.dispose();
    descriptionBookController.dispose();
    publishedYearBookController.dispose();
    super.dispose();
  }

  void markFormWithChanges() {
    if (!formHasUnsavedChanges) setState(() => formHasUnsavedChanges = true);
  }

  void _initializeFormFields() {
    titleBookController.text = activeController.model.title ?? "";
    subtitleBookController.text = activeController.model.subtitle ?? "";
    descriptionBookController.text = activeController.model.description ?? "";
    publishedYearBookController.text = activeController.model.publishedYear?.toString() ?? "";

    titleFormField = TesArteTextFormField(
      labelText: "Título", // TODO: lang
      controller: titleBookController,
      maxWidth: 650,
      maxLength: TesArteDomain.dTitle,
      onChange: (_) => markFormWithChanges(),
    );

    subtitleFormField = TesArteTextFormField(
      labelText: "Subtítulo", // TODO: lang
      controller: subtitleBookController,
      maxWidth: 650,
      maxLength: TesArteDomain.dSubtitle,
      onChange: (_) => markFormWithChanges(),
    );

    bookStatusFormField = BookStatusFormField(
      initialSelection: activeController.model.status,
      onChanged: (value) {
        bookStatusValue = value!;
        markFormWithChanges();
      }
    );

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

    bookAuthorSelector = BookAuthorSelector(
      key: bookAuthorSelectorKey,
      book: activeController,
      onChange: () => markFormWithChanges()
    );

    bookRating = TesArteRating(
      rating: activeController.model.rating,
      onChange: () => markFormWithChanges()
    );
  }

  TesArteSaveButton getSaveButton() {
    return TesArteSaveButton(
      enabled: formHasUnsavedChanges,
      formHasChanges: formHasUnsavedChanges,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          activeController.model.status = bookStatusValue;
          activeController.model.rating = bookRating.rating;
          activeController.model.title = titleBookController.text;
          activeController.model.subtitle = subtitleBookController.text;
          activeController.model.description = descriptionBookController.text;
          activeController.model.publishedYear = publishedYearBookController.text.isNotEmptyAndNotNull ? int.parse(publishedYearBookController.text) : null;
          await activeController.updateBookAuthors(bookAuthorSelectorKey.currentState!.activeBookAuthors!);
          await activeController.update();

          if (activeController.errorDB) {
            TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar gardar os cambios"); // TODO: lang
          } else {
            setState(() {
              widget.hasSavedChangesNotifier.value = true;
              formHasUnsavedChanges = false;
            });
            TesArteToast.showSuccessToast(message: "Cambios gardados correctamente"); // TODO: lang
          }
        }
      }
    );
  }

  @override
  Form build(BuildContext context) => Form(
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
                  UIBook.getCoverImage(
                    coverImagePath: activeController.model.coverImagePath,
                    status: activeController.model.status
                  ),
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
                  publishedYearFormField,
                  bookStatusFormField
                ]
              )
            ],
          ),
          bookAuthorSelector!,
          descriptionFormField,
          getSaveButton()
        ]
      ),
    ),
  );
}
