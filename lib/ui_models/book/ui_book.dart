import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/common/components/generic/tesarte_dialog.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/views/books_view/book_edit_view.dart';
import 'package:transparent_image/transparent_image.dart';

class UIBook extends StatelessWidget {
  final Book book;
  final VoidCallback? onDeleteBook;
  const UIBook({super.key, required this.book, this.onDeleteBook});


  ClipRRect _getCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: book.coverImagePath.isNotEmptyAndNotNull ? FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: book.coverImagePath!,
      ) : BookPlaceholder(),
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
      UtilText.getEllipsizedText("AUTHORS | PLACEHOLDER"),
      UtilText.getEllipsizedText("[${book.publishedYear}]")
    ];
  }

  Align _getActionButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => doEditAction()
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => doDeleteAction()
            ),
          ]
        ),
      ),
    );
  }

  void doEditAction() async {
    await navigatorKey.currentContext!.push(BookEditView.route, extra: book);

    /*if (saveChangesOnEdit) {

    }*/
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
        if (onDeleteBook != null) onDeleteBook!();
      } else {
        TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar eliminar o libro do teu estante"); // TODO: lang
      }
    }
  }

  @override
  SizedBox build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 350,
      child: Card(
        color: Theme.of(context).colorScheme.onSurface.darken(percent: .4),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getCoverImage(),
              ..._getDataBook(context),
              _getActionButtons()
            ]
          ),
        ),
      ),
    );
  }
}
