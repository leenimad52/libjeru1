import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';
import '../components/book_form.dart';
import '../actions/book_actions.dart';

class BookManager extends StatefulWidget {
  @override
  _BookManagerState createState() => _BookManagerState();
}

class _BookManagerState extends State<BookManager> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bookNumberController = TextEditingController();
  final TextEditingController _numberOfCopiesController =
      TextEditingController();
  final TextEditingController _paperTypeController = TextEditingController();
  final TextEditingController _boxNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String searchQuery = '';
  bool isTextVisible = false; // State variable to track visibility

  @override
  void initState() {
    super.initState();
    loadBooks().then((loadedBooks) {
      setState(() {
        books = loadedBooks;
        filteredBooks = loadedBooks;
      });
    });
  }

  void searchBooks(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredBooks = books
          .where((book) => book.name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void addBook() {
    if (_formKey.currentState!.validate()) {
      Book newBook = Book(
        name: _nameController.text,
        bookNumber: _bookNumberController.text,
        numberOfCopies: _numberOfCopiesController.text,
        paperType: _paperTypeController.text,
        boxNumber: _boxNumberController.text,
        customerName: _customerNameController.text,
        notes: _notesController.text,
      );

      setState(() {
        books.add(newBook);
        if (newBook.name.toLowerCase().contains(searchQuery)) {
          filteredBooks.add(newBook);
        }
      });

      saveBooks(books);
      clearForm();
    }
  }

  void deleteBook(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذا الكتاب؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  books.removeAt(index);
                  filteredBooks = books
                      .where((book) =>
                          book.name.toLowerCase().contains(searchQuery))
                      .toList();
                });
                saveBooks(books);
                Navigator.of(context).pop(); // Close the dialog after deleting
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }

///////////////////////////////////////////
  void editBook(int index) {
    // Set initial values in the text controllers with current book data
    _nameController.text = books[index].name;
    _bookNumberController.text = books[index].bookNumber;
    _numberOfCopiesController.text = books[index].numberOfCopies;
    _paperTypeController.text = books[index].paperType;
    _boxNumberController.text = books[index].boxNumber;
    _customerNameController.text = books[index].customerName;
    _notesController.text = books[index].notes;

    // Show the dialog for editing
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل الكتاب'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'اسم الكتاب'),
                ),
                TextField(
                  controller: _bookNumberController,
                  decoration: InputDecoration(labelText: 'رقم الكتاب'),
                ),
                TextField(
                  controller: _numberOfCopiesController,
                  decoration: InputDecoration(labelText: 'عدد النسخ'),
                ),
                TextField(
                  controller: _paperTypeController,
                  decoration: InputDecoration(labelText: 'نوع الورق'),
                ),
                TextField(
                  controller: _boxNumberController,
                  decoration: InputDecoration(labelText: 'رقم الصندوق'),
                ),
                TextField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'اسم الزبون'),
                ),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'ملاحظات'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Close dialog without saving
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                // Show confirmation dialog before saving the changes
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('تأكيد الحفظ'),
                      content: Text('هل أنت متأكد أنك تريد حفظ التعديلات؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pop(), // Close confirmation dialog
                          child: Text('إلغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              // Update the book with new values
                              books[index].name = _nameController.text;
                              books[index].bookNumber =
                                  _bookNumberController.text;
                              books[index].numberOfCopies =
                                  _numberOfCopiesController.text;
                              books[index].paperType =
                                  _paperTypeController.text;
                              books[index].boxNumber =
                                  _boxNumberController.text;
                              books[index].customerName =
                                  _customerNameController.text;
                              books[index].notes = _notesController.text;

                              // Update the filteredBooks list
                              filteredBooks = books
                                  .where((book) => book.name
                                      .toLowerCase()
                                      .contains(searchQuery))
                                  .toList();
                            });
                            saveBooks(books); // Save changes to storage
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                            Navigator.of(context).pop(); // Close edit dialog
                            clearForm();
                          },
                          child: Text('تأكيد'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  void clearForm() {
    _nameController.clear();
    _bookNumberController.clear();
    _numberOfCopiesController.clear();
    _paperTypeController.clear();
    _boxNumberController.clear();
    _customerNameController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/logo.jpg',
              height: 190,
              width: 90,
            ),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF74ebd5), // Start color
                Color(0xFFacb6e5), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: searchWidget()),
    );
  }

  Padding searchWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: searchBooks,
              decoration: InputDecoration(
                labelText: 'ابحث من خلال كتابة اسم الكتاب',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            if (searchQuery.isNotEmpty) searchResult(),
            Divider(
              color: Colors.white,
              thickness: 2,
            ),
            Center(child: showBooks(context)),
            Divider(
              thickness: 2,
              color: Colors.white,
            ),
            SizedBox(height: 16.0),
            BookForm(
              formKey: _formKey,
              nameController: _nameController,
              bookNumberController: _bookNumberController,
              numberOfCopiesController: _numberOfCopiesController,
              paperTypeController: _paperTypeController,
              boxNumberController: _boxNumberController,
              customerNameController: _customerNameController,
              notesController: _notesController,
              addBook: addBook,
            ),
          ],
        ),
      ),
    );
  }

/////////////
  Future<void> downloadBooksAsTextFile() async {
    // Get the directory to save the file
    final directory = await getDownloadsDirectory();
    final File file = File('${directory!.path}/books.txt');

    // Create the text content for the file
    String content = '';
    for (var book in books) {
      content += 'اسم الكتاب: ${book.name}  ||  ';
      if (book.bookNumber.isNotEmpty) {
        content += 'رقم الكتاب: ${book.bookNumber}  ||  ';
      }
      if (book.numberOfCopies.isNotEmpty) {
        content += 'عدد النسخ: ${book.numberOfCopies}  ||  ';
      }
      if (book.paperType.isNotEmpty) {
        content += 'نوع الورق: ${book.paperType}  ||  ';
      }
      if (book.boxNumber.isNotEmpty) {
        // Corrected to check boxNumber
        content +=
            'رقم الصندوق: ${book.boxNumber}  ||  '; // Corrected to use boxNumber
      }
      if (book.customerName.isNotEmpty) {
        // Corrected to check customerName
        content += 'اسم الزبون: ${book.customerName}  ||  ';
      }
      if (book.notes.isNotEmpty) {
        // Added check for notes
        content += 'ملاحظات: ${book.notes}  ||  ';
      }
      content += '\n'; // Add a new line after each book
      content += "----------------------------------------------------------";
      content += '\n';
    }

    // Write the content to the file
    await file.writeAsString(content);

    // Notify the user that the file has been saved
    print('File saved at ${file.path}');

    // Show a confirmation message in the UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ الملف في ${file.path}')),
    );
  }

// Replace the showBooks function's card section with a button to download the file
  Column showBooks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => downloadBooksAsTextFile(),
          child: Text(
            '  انقر لتحميل جميع الكتب كملف نصي  ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18), // Change text color and increase font size
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Color.fromARGB(255, 1, 91, 118), // Background color
            padding: EdgeInsets.symmetric(
                horizontal: 30.0, vertical: 16.0), // Increased padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            elevation: 5, // Shadow effect
          ),
        )

        // You can add other widgets here if needed
      ],
    );
  }

/////////////////////////////

  Row bookData(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (books[index].bookNumber.isNotEmpty)
          Row(
            children: [
              Icon(Icons.book, size: 16),
              SizedBox(width: 4),
              Text(
                'رقم الكتاب: ${books[index].bookNumber}  ||  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
            ],
          ),
        if (books[index].numberOfCopies.isNotEmpty)
          Row(
            children: [
              Icon(Icons.copy, size: 16),
              SizedBox(width: 4),
              Text(
                'عدد النسخ: ${books[index].numberOfCopies}  ||  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
            ],
          ),
        if (books[index].paperType.isNotEmpty)
          Row(
            children: [
              Icon(Icons.assignment, size: 16),
              SizedBox(width: 4),
              Text(
                'نوع الورق: ${books[index].paperType}  ||  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
            ],
          ),
        if (books[index].boxNumber.isNotEmpty)
          Row(
            children: [
              Icon(Icons.account_box_outlined, size: 16),
              SizedBox(width: 4),
              Text(
                'رقم الصندوق: ${books[index].boxNumber}  ||  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
            ],
          ),
        if (books[index].customerName.isNotEmpty)
          Row(
            children: [
              Icon(Icons.person, size: 16),
              SizedBox(width: 4),
              Text(
                'اسم الزبون: ${books[index].customerName}  ||  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
            ],
          ),
        if (books[index].notes.isNotEmpty)
          Row(
            children: [
              Icon(Icons.notes, size: 16),
              SizedBox(width: 4),
              Text(
                'ملاحظات: ${books[index].notes}  ||  ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
            ],
          ),
      ],
    );
  }

  Column searchResult() {
    return Column(
      children: [
        Text(
          'نتيجة البحث',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (searchQuery.isNotEmpty &&
            filteredBooks.isNotEmpty) // Check if there are filtered results
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              return _buildBookCard(filteredBooks[index]);
            },
          )
        else
          Padding(
            padding:
                const EdgeInsets.all(16.0), // Add padding for better appearance
            child: Row(
              children: [
                Icon(Icons.warning,
                    color: Colors.orange), // Optional icon for no results
                SizedBox(height: 8.0), // Add space between icon and text
                Text(
                  "  لا يوجد نتيجة للبحث",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBookCard(Book book) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        title: Text(
          book.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: bookData(books.indexOf(book)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => editBook(books.indexOf(book)),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteBook(books.indexOf(book)),
            ),
          ],
        ),
      ),
    );
  }
}
