import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:tesArte/common/components/generic/tesarte_divider.dart';
import 'package:tesArte/common/components/generic/tesarte_search_bar.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/models/book/book_list.dart';
import 'package:tesArte/ui_models/book/ui_book.dart';
import 'package:tesArte/views/books_view/dialogs/dialog_preview_google_books.dart';

class BooksView extends StatefulWidget {
  static const String route = "/books";
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  BookList bookshelf = BookList();

  bool bookshelfInitialized = false;

  late TesArteSearchBar tesArteSearchBar;
  late IconButton searchNewBookButton;

  @override
  void initState() {
    tesArteSearchBar = TesArteSearchBar(
      onSearch: (value) {
      }
    );

    searchNewBookButton = IconButton(
      tooltip: "Procurar novo libro", // TODO: lang
      icon: Icon(Symbols.globe_book_rounded),
      onPressed: () async {
        bool addedNewBook = await DialogPreviewGoogleBooks.show(context) ?? false;

        if (addedNewBook) setState(() => bookshelfInitialized = false);
      },
    );

    super.initState();
  }

  Future<void> initializeBookshelf() async {
    if (!bookshelfInitialized) await bookshelf.getFromActiveUser();
    setState(() => bookshelfInitialized = true);
  }

  Text _getTitleView() {
    return Text("Os meus libros", // TODO: lang
      textAlign: TextAlign.center,
      style: TextTheme.of(context).displayMedium!.copyWith(
        color: Theme.of(context).colorScheme.onPrimary
      )
    );
  }

  Widget _getBookshelf() {
    Widget bookshelfContent;

    if (bookshelf.books.isEmpty) {
      bookshelfContent = Center(
        child: Text("O estante está baleiro") // TODO: lang
      );
    } else {
      final List<UIBook> books = [];
      bookshelf.books.forEach((book) => books.add(
        UIBook(
          book: book,
          onDeleteBook: () => setState(() => bookshelfInitialized = false)
        )
      ));

      bookshelfContent = SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          spacing: 10,
          runSpacing: 10,
          children: books
        ),
      );
    }

    return bookshelfContent;
  }

  @override
  BasicLayout build(BuildContext context) {
    initializeBookshelf();

    return BasicLayout(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          _getTitleView(),
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
          Expanded(child: bookshelfInitialized ? _getBookshelf() : TesArteLoader())
        ],
      )
    );
  }
}
