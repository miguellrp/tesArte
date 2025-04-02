import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/util_dates.dart';

class GoogleBook {
  final String title;
  final String? subtitle;
  final String? publisherName;
  final int? publishedYear;
  final List<dynamic>? authors;
  final String? description;
  final String? coverImageUrl;

  final int? pageCount;

  GoogleBook({
    required this.title,
    this.subtitle,
    this.publisherName,
    this.publishedYear,
    this.authors,
    this.description,
    this.coverImageUrl,

    this.pageCount
  });

  Container getPreview() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if (coverImageUrl != null) Image.network(coverImageUrl!),
          Text(title),
          Text(authors.toString()),
        ],
      ),
    );
  }

  static Future<List<GoogleBook>> fetchFromAPI({required String term, required int limit}) async {
    const baseUrl = "https://www.googleapis.com/books/v1/volumes?q=";
    List<GoogleBook> booksFetched = [];

    final String endpoint = "$baseUrl=$term&maxResults=$limit";

    try {
      final http.Response response = await http.get(Uri.parse(endpoint));
      final results = json.decode(response.body);


      if (results["error"] != null) {
        throw Exception(results["error"]["message"]);
      }

      results["items"].forEach((item) => booksFetched.add(GoogleBook.fromGoogleBooksAPI(item["volumeInfo"])));
    } catch(exception) {
     throw Exception(exception.toString());
    }

    return booksFetched;
  }

  static GoogleBook fromGoogleBooksAPI(Map <String, dynamic> dataFetched) {
    return GoogleBook(
      title: dataFetched["title"],
      subtitle: dataFetched["subtitle"],

      publisherName: dataFetched["publisher"],
      publishedYear: _parsePublishedYearFromAPI(dataFetched["publishedDate"]),

      authors: dataFetched["authors"],
      description: dataFetched["description"],
      coverImageUrl: dataFetched["imageLinks"]?["thumbnail"],

      pageCount: dataFetched["pageCount"]
    );
  }

  /* Private method to parse the published date from the API */
  static int? _parsePublishedYearFromAPI(String? publishedDateFetched) {
    int? publishedYear;

    if (publishedDateFetched.isNotEmptyAndNotNull) {
      if (UtilDate.isDateTime(publishedDateFetched!)) {
        final DateTime publishedDate = DateTime.parse(publishedDateFetched);
        publishedYear = publishedDate.year;
      } else {
        try {
          publishedYear = int.parse(publishedDateFetched);
        } catch (exception) {
          final String? year = RegExp(r'\d{4}').firstMatch(publishedDateFetched)?.group(0);
          publishedYear = int.parse(year!);
        }
      }
    }

    return publishedYear;
  }
}