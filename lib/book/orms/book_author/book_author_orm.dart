class BookAuthorORM {
  int? bookAuthorId;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  DateTime? deathDate;
  String? picturePath;

  BookAuthorORM({
    this.bookAuthorId,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.picturePath
  });
}