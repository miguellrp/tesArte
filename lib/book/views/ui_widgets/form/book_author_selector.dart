import 'package:flutter/material.dart';
import 'package:tesArte/book/controllers/book/book_controller.dart';
import 'package:tesArte/book/controllers/book_author/book_author_controller.dart';
import 'package:tesArte/book/controllers/book_author/book_author_list_controller.dart';
import 'package:tesArte/common/components/generic/tesarte_bubble.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_style.dart';

class BookAuthorSelector extends StatefulWidget {
  final BookController book;
  final VoidCallback? onChange;

  const BookAuthorSelector({
    super.key,
    required this.book,
    this.onChange
  });

  @override
  State<BookAuthorSelector> createState() => BookAuthorSelectorState();
}

class BookAuthorSelectorState extends State<BookAuthorSelector> {
  bool bookAuthorsInitialized = false;

  Autocomplete? bookAuthorDropdown; // TODO: improve as TesArteDropdown

  BookAuthorListController? activeBookAuthors;
  BookAuthorListController? allBookAuthors;
  List<TesArteBubble>? bookAuthorBubbles;

  Future<void> initializeWidget() async {
    await getBookAuthorsData();
    await initializeBubbles();

    bookAuthorDropdown = Autocomplete<BookAuthorController>(
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          onSubmitted: (value) => onFieldSubmitted(),
          onTap: () => onFieldSubmitted(),
          decoration: const InputDecoration(
            labelText: 'Autores',
            prefixIcon: Icon(Icons.search),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 5),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmptyOrNull) {
          return const [];
        } else {
          final List<BookAuthorController> filteredBookAuthors = allBookAuthors!.where((BookAuthorController bookAuthor) => bookAuthor.getFullName().toLowerCase().contains(textEditingValue.text.toLowerCase())).toList();
          return filteredBookAuthors.map((BookAuthorController bookAuthor) => bookAuthor).toList();
        }
      },
      displayStringForOption: (BookAuthorController bookAuthor) => bookAuthor.getFullName(),
      onSelected: (BookAuthorController bookAuthor) {
        if (!activeBookAuthors!.contains(bookAuthor)) {
          activeBookAuthors!.add(bookAuthor);
          widget.onChange?.call();
        }
      },
    );
  }

  Future<void> getBookAuthorsData() async {
    if (!bookAuthorsInitialized) {
      activeBookAuthors = BookAuthorListController();
      allBookAuthors = BookAuthorListController();

      await activeBookAuthors!.getFromBook(widget.book);
      await allBookAuthors!.getAll();

      if (activeBookAuthors!.errorDB) {
        TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar obter a autoría deste libro"); // TODO: lang
      } else {
        bookAuthorsInitialized = true;
      }
    }
  }

  Future<void> initializeBubbles() async {
    if (activeBookAuthors != null) bookAuthorBubbles = await _getBookAuthorsBubbles();
  }

  Future<List<TesArteBubble>> _getBookAuthorsBubbles() async {
    List<TesArteBubble> authorBubbles = [];

    for (final BookAuthorController bookAuthor in activeBookAuthors!) {
      authorBubbles.add(TesArteBubble(
        bubbleLeading: bookAuthor.getPicture(),
        bubbleText: bookAuthor.getFullName(),
        onRemove: () {
          setState(() => activeBookAuthors!.remove(bookAuthor));
          widget.onChange?.call();
        }
      ));
    }
    setState(() {});

    return authorBubbles;
  }


  @override
  Wrap build(BuildContext context) {
    initializeWidget();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("Autoría:", style: TextTheme.of(context).labelLarge!.copyWith( // TODO: lang
          color: Theme.of(context).colorScheme.onPrimary.withAlpha(200)
        )),
        Container(
          padding: bookAuthorBubbles != null ? const EdgeInsets.all(8) : null,
          decoration: bookAuthorBubbles != null ? UtilStyle.getFormFieldDecoration() : null,
          child: Column(
            spacing: 10,
            children: [
              bookAuthorDropdown??TesArteLoader(loaderSize: LoaderSize.small),
              if (bookAuthorBubbles == null) TesArteLoader(loaderSize: LoaderSize.small)
              else if (bookAuthorBubbles!.isEmpty) Text("Autoría desconocida" /*TODO: lang*/, style: TextTheme.of(context).bodyMedium!.copyWith(fontStyle: FontStyle.italic))
              else Wrap(
                spacing: 15,
                runSpacing: 15,
                children: bookAuthorBubbles!
              )
            ]
          ),
        )
      ],
    );
  }
}
