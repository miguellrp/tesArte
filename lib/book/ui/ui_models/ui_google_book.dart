import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/controllers/book_author/book_author_controller.dart';
import 'package:tesArte/book/controllers/book_author/book_author_list_controller.dart';
import 'package:tesArte/book/dialogs/book/dialog_description_google_book.dart';
import 'package:tesArte/book/models/book/google_book.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/models/model_list.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';
import 'package:transparent_image/transparent_image.dart';

class UIGoogleBook extends StatefulWidget {
  final GoogleBook googleBook;

  const UIGoogleBook({super.key, required this.googleBook});

  @override
  State<UIGoogleBook> createState() => _UIGoogleBookState();
}

class _UIGoogleBookState extends State<UIGoogleBook> {
  late final String authors;

  @override
  void initState() {
    authors = (widget.googleBook.authorsNames != null && widget.googleBook.authorsNames!.isNotEmpty) ? widget.googleBook.authorsNames!.join(" | ") : "Autoría desconocida"; // TODO: lang
    super.initState();
  }

  ClipRRect _getCoverImageBook() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget.googleBook.coverImageUrl.isNotEmptyAndNotNull ? FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: widget.googleBook.coverImageUrl!,
      ) : BookPlaceholder(),
    );
  }

  Column _getDataBook() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        UtilText.getEllipsizedText(widget.googleBook.title,
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextTheme.of(context).titleSmall!.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.secondary.withAlpha(170)
          )
        ),
        Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          alignment: WrapAlignment.start,
          children: [
            UtilText.getEllipsizedText(authors),
            UtilText.getEllipsizedText("[${widget.googleBook.publishedYear}]"),
          ],
        )
      ],
    );
  }

  Align _getActionButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Wrap(
        spacing: 2,
        children: [
          if (widget.googleBook.description.isNotEmptyAndNotNull) IconButton(
            tooltip: "Ver descrición do libro", // TODO: lang
            icon: Icon(Symbols.book_5),
            onPressed: () => DialogDescriptionGoogleBook.show(
              context,
              titleBook: widget.googleBook.title,
              descriptionBook: widget.googleBook.description!,
            )
          ),
          IconButton(
            tooltip: "Engadir libro ó estante", // TODO: lang
            icon: Icon(Icons.add),
            onPressed: () async {
              final BookController selectedBook = BookController.fromGoogleBook(widget.googleBook);
              selectedBook.model.userId = TesArteSession.instance.getActiveUser()!.userId;

              await selectedBook.add();

              if (selectedBook.errorDB) {
                if (selectedBook.errorDBType == "CONSTRAINT ERROR: Book already exists in database") {
                  TesArteToast.showWarningToast(message: "Este libro xa se engadiu ó teu estante"); // TODO: lang
                } else {
                  TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar engadir o libro ó teu estante"); // TODO: lang
                }
              } else {
                final BookAuthorListController bookAuthorsList = BookAuthorListController();
                int bookAuthorsCreated = await bookAuthorsList.createAuthorsFromGoogleBook(widget.googleBook); // TODO: notify amount authors created

                if (bookAuthorsList.errorDB) {
                  TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar crear a autoría deste libro"); // TODO: lang
                } else {
                  for (int bookAuthorIndex = 0; bookAuthorIndex < bookAuthorsList.length; bookAuthorIndex++) {
                    await bookAuthorsList[bookAuthorIndex].addToBook(book: selectedBook);
                  }
                  TesArteToast.showSuccessToast(message: "Engadiuse o libro ó teu estante"); // TODO: lang
                }

                if (mounted) Navigator.of(context).pop(!bookAuthorsList.errorDB);
              }
            }
          ),
        ]
      )
    );
  }

  @override
  Container build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Color(0xFF413D3D),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 0),
            blurRadius: 9,
            spreadRadius: 3),
        ]
      ),
      child: Row(
        spacing: 15,
        children: [
          _getCoverImageBook(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                _getDataBook(),
                _getActionButtons()
              ],
            ),
          ),
        ],
      ),
    );
  }
}