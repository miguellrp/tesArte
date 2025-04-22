import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/generic/tesarte_dialog.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/books_view/book_edit_view.dart';
import 'package:tesArte/views/books_view/components/book_status_preview.dart';
import 'package:transparent_image/transparent_image.dart';

class UIBook extends StatelessWidget {
  final Book book;
  /// [VoidCallback] that will be called when the book is modified or deleted.
  final VoidCallback? onModification;
  const UIBook({super.key, required this.book, this.onModification});


  ClipRRect _getCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          if (book.coverImagePath.isNotEmptyAndNotNull) FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: book.coverImagePath!,
            width: Book.bookCoverMiniatureWidth,
            height: Book.bookCoverMiniatureHeight,
            fit: BoxFit.fill,
          )
          else BookPlaceholder(),
          Positioned(left: 10, top: 0, child: BookStatusPreview(status: book.status))
      ]),
    );
  }

  List<Widget> _getDataBook(BuildContext context) {
    return [
      UtilText.getEllipsizedText(book.title!,
        maxLines: 2,
        style: TextTheme.of(context).titleSmall!.copyWith(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.secondary.withAlpha(170)
        )
      ),
      UtilText.getEllipsizedText(book.authorsList!.map((author) => author.name).join(" | ")),
      UtilText.getEllipsizedText("[${book.publishedYear??"s.f."}]")
    ];
  }

  Align _getActionButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(navigatorKey.currentContext!).colorScheme.surfaceTint.withAlpha(40)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TesArteIconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(navigatorKey.currentContext!).colorScheme.tertiary.withAlpha(110),
              withSquareShape: true,
              onPressed: () => doEditAction()
            ),
            TesArteIconButton(
              icon: Icon(Icons.delete),
              color: Colors.redAccent.withAlpha(120),
              withSquareShape: true,
              onPressed: () => doDeleteAction()
            ),
          ]
        ),
      ),
    );
  }

  void doEditAction() async {
    bool didChange = await navigatorKey.currentContext!.push(BookEditView.route, extra: book)??false;

    if (didChange && onModification != null) onModification!();
  }

  void doDeleteAction() async {
    bool confirmDeleteBook = await TesArteDialog.show(navigatorKey.currentContext!,
      dialogType: TesArteDialogType.warning,
      titleDialog: "Eliminar libro", // TODO: lang
      subtitleDialog: "Vaise eliminar o siguiente libro do teu estante:", // TODO: lang
      coloredText: book.title
    ) ?? false;

    if (confirmDeleteBook) {
      final int booksDeleted = await book.deleteBook();

      if (!book.errorDB && booksDeleted == 1) {
        TesArteToast.showSuccessToast(message: "Eliminouse correctamente o libro do teu estante"); // TODO: lang
        if (onModification != null) onModification!();
      } else {
        TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar eliminar o libro do teu estante"); // TODO: lang
      }
    }
  }

  @override
  SizedBox build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 380,
      child: Card(
        color: Theme.of(context).colorScheme.onSurface.darken(percent: .4),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getCoverImage(),
              ..._getDataBook(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (book.rating != null) TesArteRating(rating: book.rating, readOnly: true)
                  else SizedBox.shrink(),
                  _getActionButtons()
                ]
              )

            ]
          ),
        ),
      ),
    );
  }
}
