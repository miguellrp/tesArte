import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/controllers/book_author/book_author_list_controller.dart';
import 'package:tesArte/book/views/ui_widgets/book_status_preview.dart';
import 'package:tesArte/common/components/form/tesarte_rating/tesarte_rating.dart';
import 'package:tesArte/common/components/generic/tesarte_card.dart';
import 'package:tesArte/common/components/generic/tesarte_dialog.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_text.dart';
import 'package:tesArte/common/utils/util_viewport.dart';
import 'package:tesArte/book/views/book_edit_view.dart';
import 'package:transparent_image/transparent_image.dart';

class UIBook extends StatefulWidget {
  static final double bookCoverMiniatureWidth = 128;
  static final double bookCoverMiniatureHeight = 183;

  final BookController controller;
  /// [VoidCallback] that will be called when the book is modified or deleted.
  final VoidCallback? onModification;

  const UIBook({super.key, required this.controller, this.onModification});

  @override
  State<UIBook> createState() => _UIBookState();

  static ClipRRect getCoverImage({required String? coverImagePath, required int? status}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          if (coverImagePath.isNotEmptyAndNotNull) FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: coverImagePath!,
            width: UIBook.bookCoverMiniatureWidth,
            height: UIBook.bookCoverMiniatureHeight,
            fit: BoxFit.fill,
          )
          else BookPlaceholder(),
          Positioned(left: 10, top: 0, child: BookStatusPreview(status: status))
        ]),
    );
  }
}

class _UIBookState extends State<UIBook> {
  BookController get activeController => widget.controller;
  bool verticalDirection = false;
  BookAuthorListController? bookAuthorsList;

  List<Widget>? bookData;

  ClipRRect get coverImage => ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: activeController.model.coverImagePath.isNotEmptyAndNotNull ? FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: activeController.model.coverImagePath!,
    ) : BookPlaceholder(),
  );

  void initializeBookData() async {
    if (bookAuthorsList == null) {
      bookAuthorsList = BookAuthorListController();
      await bookAuthorsList!.getFromBook(activeController);
    }

    if (mounted) {
      bookData = _getDataBook();
      setState(() {});
    }
  }

  @override
  didChangeDependencies() {
    verticalDirection = UtilViewport.getScreenWidth(context) < 600;
    super.didChangeDependencies();
  }

  List<Widget> _getDataBook() {
    List<Widget> dataBookWidgets = [];

    if (navigatorKey.currentContext!.mounted) {
      dataBookWidgets = [
        UtilText.getEllipsizedText(activeController.model.title!,
          maxLines: 2,
          textAlign: verticalDirection ? TextAlign.center : TextAlign.start,
          style: TextTheme.of(context).titleSmall!.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.secondary.withAlpha(170)
          )
        ),
        if (bookAuthorsList!.isNotEmpty) UtilText.getEllipsizedText(bookAuthorsList!.getAuthorNamesJoined())
        else UtilText.getEllipsizedText("Autoría desconocida"), // TODO: lang
        UtilText.getEllipsizedText("[${activeController.model.publishedYear??"s.f."}]")
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
    bool didChange = await navigatorKey.currentContext!.push(BookEditView.route, extra: widget.controller)??false;

    if (didChange && widget.onModification != null) widget.onModification!();
  }

  void _doDeleteAction() async {
    bool confirmDeleteBook = await TesArteDialog.show(navigatorKey.currentContext!,
      dialogType: TesArteDialogType.warning,
      titleDialog: "Eliminar libro", // TODO: lang
      subtitleDialog: "Vaise eliminar o siguiente libro do teu estante:", // TODO: lang
      coloredText: activeController.model.title
    ) ?? false;

    if (confirmDeleteBook) {
      final int booksDeleted = await activeController.delete();

      if (!activeController.errorDB && booksDeleted == 1) {
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
        UIBook.getCoverImage(
          coverImagePath: activeController.model.coverImagePath,
          status: activeController.model.status
        ),
        TesArteRating(rating: activeController.model.rating, readOnly: true),

        if (bookData != null) ...bookData!
        else CircularProgressIndicator(), // TODO: containerPlaceholderLoader

        Align(alignment: Alignment.bottomRight, child: _getActionButtons())
      ]
    )
  ];

  List<Widget> _getHorizontalCard() => [
    UIBook.getCoverImage(
      coverImagePath: activeController.model.coverImagePath,
      status: activeController.model.status
    ),

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
          TesArteRating(rating: activeController.model.rating, readOnly: true),
          _getActionButtons()
        ],
      ),
    )
  ];

  @override
  Container build(BuildContext context) {
    initializeBookData();

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
