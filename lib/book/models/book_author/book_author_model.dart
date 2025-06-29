import 'package:tesArte/book/orms/book_author/book_author_orm.dart';

class BookAuthorModel {
  final BookAuthorORM _bookAuthorORM;
  BookAuthorModel({BookAuthorORM? bookAuthorORM}) : _bookAuthorORM = bookAuthorORM ?? BookAuthorORM();

  // *** GETTERS/SETTERS ***
  int? get bookAuthorId => _bookAuthorORM.bookAuthorId;
  set bookAuthorId(int? bookAuthorId) => _bookAuthorORM.bookAuthorId = bookAuthorId;

  String? get firstName => _bookAuthorORM.firstName;
  set firstName(String? firstName) => _bookAuthorORM.firstName = firstName;

  String? get lastName => _bookAuthorORM.lastName;
  set lastName(String? lastName) => _bookAuthorORM.lastName = lastName;

  DateTime? get birthDate => _bookAuthorORM.birthDate;
  set birthDate(DateTime? birthDate) => _bookAuthorORM.birthDate = birthDate;

  DateTime? get deathDate => _bookAuthorORM.deathDate;
  set deathDate(DateTime? deathDate) => _bookAuthorORM.deathDate = deathDate;

  String? get picturePath => _bookAuthorORM.picturePath;
  set picturePath(String? picturePath) => _bookAuthorORM.picturePath = picturePath;
// ***********************
}