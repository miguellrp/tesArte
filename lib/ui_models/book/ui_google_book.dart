import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:tesArte/common/components/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/models/book/google_book.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';
import 'package:transparent_image/transparent_image.dart';

class UIGoogleBook extends StatefulWidget {
  GoogleBook googleBook;

  UIGoogleBook({super.key, required this.googleBook});

  @override
  State<UIGoogleBook> createState() => _UIGoogleBookState();
}

class _UIGoogleBookState extends State<UIGoogleBook> {
  late final String authors;

  @override
  void initState() {
    authors = (widget.googleBook.authors != null && widget.googleBook.authors!.isNotEmpty) ? widget.googleBook.authors!.join(" | ") : "Anónimo"; // TODO: lang
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
          IconButton(
              tooltip: "Ver descrición do libro", // TODO: lang
              icon: Icon(Symbols.book_5),
              onPressed: null // TODO: show book description
          ),
          IconButton(
            tooltip: "Engadir libro ó estante", // TODO: lang
            icon: Icon(Icons.add),
            onPressed: () async {
              Book selectedBook = Book.fromGoogleBook(widget.googleBook);
              selectedBook.userId = TesArteSession.instance.getActiveUser()!.userId;

              await selectedBook.addBook();

              if (mounted) {
                if (!selectedBook.errorDB) {
                  TesArteToast.showSuccessToast(context, message: "Engadiuse o libro ó teu estante"); // TODO: lang
                  Navigator.of(context).pop(true);
                } else {
                  TesArteToast.showErrorToast(context, message: "Ocurriu un erro ó intentar engadir o libro ó teu estante"); // TODO: lang
                }
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