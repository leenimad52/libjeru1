class Book {
  String name;
  String bookNumber;
  String numberOfCopies;
  String paperType;
  String boxNumber;
  String customerName;
  String notes;

  Book({
    required this.name,
    required this.bookNumber,
    required this.numberOfCopies,
    required this.paperType,
    required this.boxNumber,
    required this.customerName,
    required this.notes
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bookNumber': bookNumber,
      'numberOfCopies': numberOfCopies,
      'paperType': paperType,
      'boxNumber': boxNumber,
      'customerName': customerName,
      'notes':notes
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['name'],
      bookNumber: json['bookNumber'],
      numberOfCopies: json['numberOfCopies'],
      paperType: json['paperType'],
      boxNumber: json['boxNumber'],
      customerName: json['customerName'],
      notes: json['notes']
    );
  }
}
