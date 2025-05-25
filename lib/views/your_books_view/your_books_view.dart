import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:tesArte/common/components/generic/tesarte_divider.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';
import 'package:tesArte/common/components/generic/tesarte_search_bar.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';
import 'package:tesArte/models/book/book.dart';
import 'package:tesArte/models/book/book_list.dart';
import 'package:tesArte/ui_models/book/ui_book.dart';
import 'package:tesArte/views/your_books_view/dialogs/dialog_preview_google_books.dart';

class YourBooksView extends StatefulWidget {
  static const String route = "/your_books";
  const YourBooksView({super.key});

  @override
  State<YourBooksView> createState() => _YourBooksViewState();
}

class _YourBooksViewState extends State<YourBooksView> {
  BookList bookshelf = BookList();
  String searchTerm = "";

  bool bookshelfInitialized = false;
  bool didSearchBook = false;

  late TesArteSearchBar tesArteSearchBar;
  late TesArteIconButton searchNewBookButton;

  @override
  void initState() {
    tesArteSearchBar = TesArteSearchBar(
      onSearch: (value) {
        if (searchTerm != value) {
          searchTerm = value;
          setState(() {
            bookshelfInitialized = false;
            didSearchBook = true;
          });
        }
      }
    );

    searchNewBookButton = TesArteIconButton(
      tooltipText: "Procurar novo libro", // TODO: lang
      icon: Icon(Symbols.globe_book_rounded),
      padding: 8,
      onPressed: () async {
        bool addedNewBook = await DialogPreviewGoogleBooks.show(context) ?? false;

        if (addedNewBook) setState(() => bookshelfInitialized = false);
      },
    );

    super.initState();
  }

  Future<void> initializeBookshelf() async {
    if (!bookshelfInitialized) {
      await bookshelf.getFromActiveUser(whereParams: [searchTerm, searchTerm]);

      if (bookshelf.errorDB) {
        TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar obter os libros"); // TODO: lang
      }
    }

    setState(() => bookshelfInitialized = true);
  }

  Widget _getBooks() {
    Widget bookshelfContent;

    if (bookshelf.books.isEmpty) {
      bookshelfContent = Center(
        child: Text(didSearchBook ? "Non se atoparon libros co termo procurado" : "O estante está baleiro.") // TODO: lang
      );
    } else {
      bookshelfContent = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: bookshelf.books.length,
        itemBuilder: (context, index) => UIBook(
          book: bookshelf.books[index],
          onModification: () => setState(() => bookshelfInitialized = false)
        ),
      );
    }

    return bookshelfContent;
  }

  @override
  BasicLayout build(BuildContext context) {
    initializeBookshelf();

    return BasicLayout(
      titleView: AppLocalizations.of(context)!.yourBooks,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 5,
            children: [
              Flexible(fit: FlexFit.loose, child: tesArteSearchBar),
              searchNewBookButton,
            ]
          ),
          TesArteDivider(),
          Expanded(
            child: bookshelfInitialized ? _getBooks() : TesArteLoader(),
          )
        ],
      )
    );
  }
}
