enum BooksDBFilters {
  userId("a_user_id"),
  bookId("a_book_id"),
  title("a_title"),
  subtitle("a_subtitle"),
  publishedYear("a_published_year");

  final String _whereQuery;

  String get whereQuery => "$_whereQuery = ?";
  String get whereLowerLikeQuery => "LOWER($_whereQuery) LIKE LOWER('%' || ? || '%')";

  const BooksDBFilters(this._whereQuery);
}