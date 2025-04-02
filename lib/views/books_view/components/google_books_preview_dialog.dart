import 'package:flutter/material.dart';
import 'package:tesArte/common/components/tesarte_search_bar.dart';
import 'package:tesArte/models/book/google_book.dart';

class GoogleBooksPreviewDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        List<GoogleBook> booksFound = [];

        return StatefulBuilder(
          builder: (context, setState) {
            final TesArteSearchBar tesArteSearchBar = TesArteSearchBar(
                onSearch: (value) async {
                  if (booksFound.isNotEmpty) booksFound.clear();
                  booksFound = await GoogleBook.fetchFromAPI(term: value, limit: 10);

                  setState(()  {});
                }
            );

            return Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  Text("Procurar en Google Books"), // TODO: lang
                  tesArteSearchBar,
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: booksFound.length,
                        itemBuilder: (context, index) {
                          return booksFound[index].getPreview();
                        }
                      )
                    )
                  )
                ]
              )
            );
          },
        );
      },
    );
  }
}