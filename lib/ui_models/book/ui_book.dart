import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/generic/tesarte_card.dart';
import 'package:tesArte/common/components/generic/tesarte_dialog.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/common/utils/util_viewport.dart';
import 'package:tesArte/models/author/book/book_author_list.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/your_books_view/book_edit_view.dart';
import 'package:tesArte/views/your_books_view/components/book_status_preview.dart';
import 'package:transparent_image/transparent_image.dart';

class UIBook extends StatefulWidget {
  final Book book;
  /// [VoidCallback] that will be called when the book is modified or deleted.
  final VoidCallback? onModification;

  const UIBook({super.key, required this.book, this.onModification});

  @override
  State<UIBook> createState() => _UIBookState();
}

class _UIBookState extends State<UIBook> {
  bool verticalDirection = false;

  late final ClipRRect bookCoverImage;
  late final Container bookActionButtons;

  List<Widget>? bookData;

  @override
  void initState() {
    bookCoverImage = _getCoverImage();
    bookActionButtons = _getActionButtons();
    initializeBookData();

    super.initState();
  }

  void initializeBookData() async {
    bookData ??= await _getDataBook(context);
    setState(() {});
  }

  @override
  didChangeDependencies() {
    verticalDirection = UtilViewport.getScreenWidth(context) < 600;
    super.didChangeDependencies();
  }

  ClipRRect _getCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          if (widget.book.coverImagePath.isNotEmptyAndNotNull) FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.book.coverImagePath!,
            width: Book.bookCoverMiniatureWidth,
            height: Book.bookCoverMiniatureHeight,
            fit: BoxFit.fill,
          )
          else BookPlaceholder(),
          Positioned(left: 10, top: 0, child: BookStatusPreview(status: widget.book.status))
      ]),
    );
  }

  Future<List<Widget>> _getDataBook(BuildContext context) async {
    List<Widget> dataBookWidgets = [];
    final BookAuthorList bookAuthorsList = BookAuthorList();
    await bookAuthorsList.getFromBook(book: widget.book);

    if (navigatorKey.currentContext!.mounted) {
      dataBookWidgets = [
        UtilText.getEllipsizedText(widget.book.title!,
          maxLines: 2,
          textAlign: verticalDirection ? TextAlign.center : TextAlign.start,
          style: TextTheme.of(context).titleSmall!.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.secondary.withAlpha(170)
          )
        ),
        if (bookAuthorsList.isNotEmpty) UtilText.getEllipsizedText(bookAuthorsList.getAllNames().join(" | "))
        else UtilText.getEllipsizedText("Anónimo"), // TODO: lang
        UtilText.getEllipsizedText("[${widget.book.publishedYear??"s.f."}]")
      ];
    }

    return dataBookWidgets;
  }

  Container _getActionButtons() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(navigatorKey.currentContext!).colorScheme.surfaceTint.withAlpha(40)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TesArteIconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(navigatorKey.currentContext!).colorScheme.tertiary.withAlpha(110),
            withSquareShape: true,
            onPressed: () => _doEditAction()
          ),
          TesArteIconButton(
            icon: Icon(Icons.delete),
            color: Colors.redAccent.withAlpha(120),
            withSquareShape: true,
            onPressed: () => _doDeleteAction()
          ),
        ]
      ),
    );
  }

  void _doEditAction() async {
    bool didChange = await navigatorKey.currentContext!.push(BookEditView.route, extra: widget.book)??false;

    if (didChange && widget.onModification != null) widget.onModification!();
  }

  void _doDeleteAction() async {
    bool confirmDeleteBook = await TesArteDialog.show(navigatorKey.currentContext!,
      dialogType: TesArteDialogType.warning,
      titleDialog: "Eliminar libro", // TODO: lang
      subtitleDialog: "Vaise eliminar o siguiente libro do teu estante:", // TODO: lang
      coloredText: widget.book.title
    ) ?? false;

    if (confirmDeleteBook) {
      final int booksDeleted = await widget.book.deleteBook();

      if (!widget.book.errorDB && booksDeleted == 1) {
        TesArteToast.showSuccessToast(message: "Eliminouse correctamente o libro do teu estante"); // TODO: lang
        if (widget.onModification != null) widget.onModification!();
      } else {
        TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar eliminar o libro do teu estante"); // TODO: lang
      }
    }
  }

  List<Widget> _getVerticalCard() => [
    Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        bookCoverImage,
        TesArteRating(rating: widget.book.rating, readOnly: true),

        if (bookData != null) ...bookData!
        else CircularProgressIndicator(), // TODO: containerPlaceholderLoader

        Align(alignment: Alignment.bottomRight, child: _getActionButtons())
      ]
    )
  ];

  List<Widget> _getHorizontalCard() => [
    bookCoverImage,

    Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          if (bookData != null) ...bookData!
          else CircularProgressIndicator() // TODO: containerPlaceholderLoader
        ],
      ),
    ),

    Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TesArteRating(rating: widget.book.rating, readOnly: true),
          _getActionButtons()
        ],
      ),
    )
  ];

  @override
  Container build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: verticalDirection ? double.maxFinite : 223),
      child: TesArteCard(
        cardColor: Theme.of(context).colorScheme.onSurface.darken(percent: .4),
        spacing: 15,
        direction: verticalDirection ? Axis.vertical : Axis.horizontal,
        widgets: verticalDirection ? _getVerticalCard() : _getHorizontalCard()
      )
    );
  }
}
