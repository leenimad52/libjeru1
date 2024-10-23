// lib/actions/book_actions.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

Future<void> saveBooks(List<Book> books) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books.json');

    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    String jsonString = jsonEncode(books.map((book) => book.toJson()).toList());
    await file.writeAsString(jsonString);
    print("Books saved successfully.");
  } catch (e) {
    print("Error saving books: $e");
  }
}

Future<List<Book>> loadBooks() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/books.json');
  List<Book> loadedBooks = [];

  if (await file.exists()) {
    String contents = await file.readAsString();
    List<dynamic> jsonList = jsonDecode(contents);
    loadedBooks = jsonList.map((json) => Book.fromJson(json)).toList();
  }

  return loadedBooks;
}
