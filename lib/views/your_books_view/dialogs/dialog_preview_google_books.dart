import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_search_bar.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/models/book/google_book.dart';
import 'package:tesArte/ui_models/book/ui_google_book.dart';

class _DialogPreviewGoogleBooksWidget extends StatefulWidget {
  const _DialogPreviewGoogleBooksWidget();

  @override
  State<_DialogPreviewGoogleBooksWidget> createState() => _DialogPreviewGoogleBooksWidgetState();
}

class _DialogPreviewGoogleBooksWidgetState extends State<_DialogPreviewGoogleBooksWidget> {
  Future<List<GoogleBook>>? _futureBooks;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 650,
        height: 650,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Text("Procurar novo libro", style: TextTheme.of(context).titleMedium), // TODO: lang
            TesArteSearchBar(
              onSearch: (value) => setState(() {
                if (value.isNotEmptyAndNotNull) _futureBooks = GoogleBook.fetchFromAPI(term: value, limit: 10);
              })
            ),
            Expanded(
              child: _futureBooks == null
                  ? const Center(child: Text("Introduce un término para buscar"))
                  : FutureBuilder<List<GoogleBook>>(
                future: _futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return TesArteLoader();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Ocurriu un erro ó intentar procurar libros",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ), // TODO: lang
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<GoogleBook> booksFound = snapshot.data!;
                    return ListView.builder(
                      itemCount: booksFound.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: UIGoogleBook(googleBook: booksFound[index])
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Non se atoparon libros co termo procurado")); // TODO: lang
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogPreviewGoogleBooks {
  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => const _DialogPreviewGoogleBooksWidget(),
    );
  }
}