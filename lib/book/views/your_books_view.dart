import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/dialogs/book/dialog_preview_google_books.dart';
import 'package:tesArte/book/models/book/book_model.dart';
import 'package:tesArte/book/ui/ui_models/ui_book.dart';
import 'package:tesArte/common/components/generic/tesarte_divider.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/generic/tesarte_search_bar.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';
import 'package:tesArte/models/model_list.dart';

class YourBooksView extends StatefulWidget {
  static const String route = "/your_books";

  const YourBooksView({super.key});

  @override
  State<YourBooksView> createState() => _YourBooksViewState();
}
class _YourBooksViewState extends State<YourBooksView> {
  final BookController controller = BookController(model: BookModel());
  ModelList<BookController>? bookshelf;

  String? searchTerm;

  bool bookshelfInitialized = false;

  late final TesArteSearchBar searchBar;
  late final TesArteIconButton searchNewBookButton;

  void fetchBookshelf() async {
    if (!bookshelfInitialized) {
      bookshelf = await controller.getFromActiveUser(termFiltered: searchTerm);
      setState(() => bookshelfInitialized = true);
    }
  }

  @override
  void initState() {
    searchBar = TesArteSearchBar(
      maxWidth: 450,
      onSearch: (value) async => setState(() {
        searchTerm = value;
        bookshelfInitialized = false;
      })
    );

    searchNewBookButton = TesArteIconButton(
      tooltipText: "Procurar novo libro", // TODO: lang
      icon: Icon(Symbols.globe_book_rounded),
      padding: 8,
      onPressed: () async {
        bool addedNewBook = await DialogPreviewGoogleBooks.show(context) ?? false;
        if (addedNewBook) setState(() => bookshelfInitialized = false);
      }
    );

    super.initState();
  }

  Widget getContent() {
    Widget content = Center(
      child: Text(searchTerm.isEmptyOrNull
        ? "O estante está baleiro."
        : "Non se atoparon libros co termo procurado.") // TODO: lang
    );

    if (bookshelf!.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: bookshelf!.length,
        itemBuilder: (context, index) => UIBook(
          controller: bookshelf![index],
          onModification: () async => setState(() => bookshelfInitialized = false),
        )
      );
    }

    return content;
  }

  @override
  BasicLayout build(BuildContext context) {
    fetchBookshelf();

    return BasicLayout(
      titleView: AppLocalizations.of(context)!.yourBooks,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 5,
            children: [
              Flexible(child: searchBar),
              searchNewBookButton,
            ]
          ),
          TesArteDivider(),
          Expanded(child: bookshelfInitialized ? getContent() : TesArteLoader())
        ],
      )
    );
  }
}