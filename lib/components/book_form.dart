import 'package:flutter/material.dart';

class BookForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController bookNumberController;
  final TextEditingController numberOfCopiesController;
  final TextEditingController paperTypeController;
  final TextEditingController boxNumberController;
  final TextEditingController customerNameController;
  final TextEditingController notesController;

  final Function addBook;

  const BookForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.bookNumberController,
    required this.numberOfCopiesController,
    required this.paperTypeController,
    required this.boxNumberController,
    required this.customerNameController,
    required this.addBook,
    required this.notesController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE9E4F0),
      elevation: 8, // Increased elevation for a deeper shadow
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 230, 235, 236),
          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFF86FDE8), // Start color
          //     Color.fromARGB(255, 255, 255, 255), // End color // End color
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(15.0), // Match Card border radius
        ),
        child: SingleChildScrollView(
          // Make the form scrollable
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Increased padding
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'إضافة كتاب جديد', // Title for the form
                      style: TextStyle(
                        fontSize: 28, // Increased font size
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade900, // Changed text color
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0), // Increased space after the title

                  // First Row for Book Name and Book Number
                  _buildTextFormFieldRow(
                    label1: 'اسم الكتاب',
                    controller1: nameController,
                    label2: 'رقم الكتاب',
                    controller2: bookNumberController,
                    icon1: Icons.book,
                    icon2: Icons.confirmation_number,
                    isRequired: true, // Indicate that this field is required
                  ),
                  SizedBox(height: 16.0), // Space after the row

                  // Second Row for Number of Copies and Paper Type
                  _buildTextFormFieldRow(
                    label1: 'عدد النسخ',
                    controller1: numberOfCopiesController,
                    label2: 'نوع الورق',
                    controller2: paperTypeController,
                    icon1: Icons.copy,
                    icon2: Icons.pages,
                    isRequired: false, // Optional field
                  ),
                  SizedBox(height: 16.0), // Space after the row

                  // Third Row for Box Number and Customer Name
                  _buildTextFormFieldRow(
                    label1: 'رقم الصندوق',
                    controller1: boxNumberController,
                    label2: 'اسم الزبون',
                    controller2: customerNameController,
                    icon1: Icons.storage,
                    icon2: Icons.person,
                    isRequired: false, // Optional field
                  ),
                  SizedBox(height: 30), // Space before the button
                  TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: "ملاحظات",
                      prefixIcon: Icon(Icons.notes),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0), // Padding inside the field
                    ),
                  ),
                  SizedBox(height: 10), // Space before the button

                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        addBook();
                        // Clear all text fields after adding the book
                        nameController.clear();
                        bookNumberController.clear();
                        numberOfCopiesController.clear();
                        paperTypeController.clear();
                        boxNumberController.clear();
                        customerNameController.clear();
                        notesController.clear();

                        // Show a Snackbar indicating success
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'تم إضافة الكتاب بنجاح!'), // Success message
                            duration: Duration(
                                seconds: 2), // Duration for the Snackbar
                          ),
                        );
                      }
                    },
                    child: Text('إضافة'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 30.0),
                      backgroundColor:
                          Color.fromARGB(255, 1, 91, 118), // Button color
                      textStyle: TextStyle(fontSize: 18), // Text style
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded button
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildTextFormFieldRow({
    required String label1,
    required TextEditingController controller1,
    required String label2,
    required TextEditingController controller2,
    required IconData icon1,
    required IconData icon2,
    required bool isRequired, // New parameter to indicate if field is required
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller1,
            decoration: InputDecoration(
              labelText: label1,
              prefixIcon: Icon(icon1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 15.0), // Padding inside the field
            ),
            validator: (value) =>
                isRequired && value!.isEmpty ? 'يرجى إضافة $label1' : null,
          ),
        ),
        SizedBox(width: 16.0), // Space between fields
        Expanded(
          child: TextFormField(
            controller: controller2,
            decoration: InputDecoration(
              labelText: label2,
              prefixIcon: Icon(icon2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.blue),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 15.0), // Padding inside the field
            ),
            validator: (value) => value!.isEmpty ? null : null,
          ),
        ),
      ],
    );
  }
}
