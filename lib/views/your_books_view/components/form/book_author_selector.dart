import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_bubble.dart';
import 'package:tesArte/common/components/generic/tesarte_toast.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/common/utils/util_style.dart';
import 'package:tesArte/models/author/author.dart';
import 'package:tesArte/models/author/author_list.dart';
import 'package:tesArte/models/author/book/book_author.dart';
import 'package:tesArte/models/author/book/book_author_list.dart';
import 'package:tesArte/models/book/book.dart';

class BookAuthorSelector extends StatefulWidget {
  final Book? book;

  const BookAuthorSelector({
    super.key,
    this.book
  });

  @override
  State<BookAuthorSelector> createState() => _BookAuthorSelectorState();
}

class _BookAuthorSelectorState extends State<BookAuthorSelector> {
  final TextEditingController _controller = TextEditingController();
  bool dataInitialized = false;

  List<TesArteBubble> bookAuthorBubbles = [];

  @override
  void initState() {
    initializeWidget();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initializeWidget() async {
    await getBookAuthorsData();
    if (dataInitialized) await initializeBubbles();
  }

  Future<void> getBookAuthorsData() async {
    AuthorList allAvailableBookAuthors = AuthorList();
    await allAvailableBookAuthors.getAllAuthorsWithType(AuthorType.book);

    if (allAvailableBookAuthors.errorDB) {
      TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar obter a autoría deste libro"); // TODO: lang
    } else {
      setState(() => dataInitialized = true);
    }
  }

  Future<void> initializeBubbles() async {
    bookAuthorBubbles = await _getBookAuthorsBubbles();
  }

  Future<List<TesArteBubble>> _getBookAuthorsBubbles() async {
    List<TesArteBubble> authorBubbles = [];

    if (widget.book != null) {
      BookAuthorList bookAuthorsList = BookAuthorList();
      await bookAuthorsList.getFromBook(book: widget.book!);

      if (bookAuthorsList.errorDB) {
        TesArteToast.showErrorToast(message: "Ocurriu un erro ó intentar obter a autoría deste libro"); // TODO: lang
      } else {
        for (final BookAuthor bookAuthor in bookAuthorsList) {
          authorBubbles.add(TesArteBubble(
            bubbleText: bookAuthor.name!,
            onRemove: () => bookAuthor.deleteAuthorFromBook(),
          ));
        }
      }
    }

    return authorBubbles;
  }


  @override
  Wrap build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // TODO: lang ⬇️
        Text("Autoría:", style: TextTheme.of(context).labelLarge!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary.withAlpha(200)
        )),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: UtilStyle.getFormFieldDecoration(),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (bookAuthorBubbles.isNotEmpty) ...bookAuthorBubbles
              else if (bookAuthorBubbles.isEmpty) Text("Anónimo" /*TODO: lang*/, style: TextTheme.of(context).bodyMedium!.copyWith(fontStyle: FontStyle.italic))
              else TesArteLoader()
            ]
          ),
        )
      ],
    );
  }
}
