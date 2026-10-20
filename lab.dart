import 'dart:io';

typedef Book = Map<String, Object?>;
typedef BookPredicate = bool Function(Book book);

final List<Book> library = [
  {'title': 'Dart in Action', 'author': 'S. A. Chernyshev', 'year': 2024, 'pages': 521, 'genre': 'textbook', 'read': true},
  {'title': 'Flutter on Practice', 'author': 'F. Zametti', 'year': 2020, 'pages': 328, 'genre': 'textbook', 'read': false},
  {'title': '1984', 'author': 'George Orwell', 'year': 1949, 'pages': 320, 'genre': 'dystopia', 'read': true},
  {'title': 'Brave New World', 'author': 'Aldous Huxley', 'year': 1932, 'pages': 288, 'genre': 'dystopia', 'read': false},
  {'title': 'The Hobbit', 'author': 'J. R. R. Tolkien', 'year': 1937, 'pages': 310, 'genre': 'fantasy', 'read': true},
  {'title': 'The Lord of the Rings', 'author': 'J. R. R. Tolkien', 'year': 1954, 'pages': 1200, 'genre': 'fantasy', 'read': false},
  {'title': 'Fahrenheit 451', 'author': 'Ray Bradbury', 'year': 1953, 'pages': 158, 'genre': 'dystopia', 'read': true},
  {'title': 'Dune', 'author': 'Frank Herbert', 'year': 1965, 'pages': 700, 'genre': 'sci-fi', 'read': false},
];

Function makeCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

void main() {
  var running = true;
  final Function commandCounter = makeCounter();

  while (running) {
    print('=== BookShelf Main Menu ===');
    print('1. Show all books');
    print('2. Search by author');
    print('3. Search by title');
    print('4. Filter by genre');
    print('5. Filter by "is read" status');
    print('6. Sort books');
    print('7. Catalog statistics');
    print('8. Add new book');
    print('9. Delete book by number');
    print('10. Custom filters demo (Task 6)');
    print('0. Exit');
    stdout.write('Choose command > ');

    final String command = stdin.readLineSync()?.trim() ?? '';
    
    if (command.isNotEmpty && command != '0') {
      final int totalCommands = commandCounter();
      print('  [System: Total commands executed so far: $totalCommands]');
    }

    switch (command) {
      case '1':
        printAll(library);
      case '2':
        stdout.write('Enter author name (or part of it): ');
        final String query = stdin.readLineSync() ?? '';
        final List<Book> results = searchByField(library, 'author', query);
        printAll(results);
      case '3':
        stdout.write('Enter book title (or part of it): ');
        final String query = stdin.readLineSync() ?? '';
        final List<Book> results = searchByField(library, 'title', query);
        printAll(results);
      case '4':
        stdout.write('Enter genre: ');
        final String query = stdin.readLineSync() ?? '';
        final List<Book> results = searchByField(library, 'genre', query);
        printAll(results);
      case '5':
        stdout.write('Show read books? (yes/no): ');
        final String answer = (stdin.readLineSync() ?? '').toLowerCase().trim();
        final bool showRead = (answer == 'yes' || answer == 'y');
        final List<Book> results = filterByRead(library, showRead);
        printAll(results);
      case '6':
        print('Sort by: 1.title, 2.author, 3.year, 4.pages');
        stdout.write('Choose field > ');
        final String choice = stdin.readLineSync() ?? '';
        String field = 'title';
        if (choice == '2') field = 'author';
        if (choice == '3') field = 'year';
        if (choice == '4') field = 'pages';

        stdout.write('Descending sort? (yes/no): ');
        final String descAnswer = (stdin.readLineSync() ?? '').toLowerCase().trim();
        final bool desc = (descAnswer == 'yes' || descAnswer == 'y');

        final List<Book> sortedList = sortBy(library, field, descending: desc);
        printAll(sortedList);
      case '7':
        printStatistics(library);
      case '8':
        addNewBook();
      case '9':
        deleteBook();
      case '10':
        runCustomFiltersDemo();
      case '0':
        running = false;
        print('Work completed. Goodbye!');
      default:
        print('Unknown command! Please repeat input.');
    }
    print('\n' + '=' * 44 + '\n');
  }
}

void printAll(List<Book> books, {String emptyMessage = 'Nothing found.'}) {
  if (books.isEmpty) {
    print('  -> $emptyMessage');
    return;
  }
  print('\n--- Book Catalog List ---');
  for (int i = 0; i < books.length; i++) {
    final Book b = books[i];
    final String readStatus = (b['read'] == true) ? '[V] Read' : '[ ] Unread';
    print('${i + 1}. "${b['title']}" by ${b['author']} (${b['year']}) - ${b['pages']} p. | Genre: ${b['genre']} | $readStatus');
  }
}

List<Book> searchByField(List<Book> books, String field, String query) {
  final String lowerQuery = query.toLowerCase().trim();
  final List<Book> output = [];
  for (Book b in books) {
    final String fieldValue = (b[field] ?? '').toString().toLowerCase();
    if (fieldValue.contains(lowerQuery)) {
      output.add(b);
    }
  }
  return output;
}

List<Book> filterByRead(List<Book> books, bool isRead) {
  final List<Book> output = [];
  for (Book b in books) {
    if (b['read'] == isRead) {
      output.add(b);
    }
  }
  return output;
}

List<Book> sortBy(List<Book> books, String field, {bool descending = false}) {
  final List<Book> copy = [...books];
  
  copy.sort((Book a, Book b) {
    final Object? valA = a[field];
    final Object? valB = b[field];

    int result = 0;
    if (valA is String && valB is String) {
      result = valA.compareTo(valB);
    } else if (valA is int && valB is int) {
      result = valA.compareTo(valB);
    } else if (valA is double && valB is double) {
      result = valA.compareTo(valB);
    }

    if (descending == true) {
      return -result;
    }
    return result;
  });

  return copy;
}

void printStatistics(List<Book> books) {
  if (books.isEmpty) {
    print('No statistics available for an empty catalog.');
    return;
  }

  print('\n--- CATALOG STATISTICS ---');

  final int totalBooks = books.length;
  final int readCount = books.where((Book b) => b['read'] == true).length;
  print('Total books: $totalBooks');
  print('Read books: $readCount');

  final int totalPages = books.fold(0, (int sum, Book b) {
    final int bookPages = b['pages'] as int? ?? 0;
    return sum + bookPages;
  });
  final double averagePages = totalPages / totalBooks;
  print('Total pages in catalog: $totalPages');
  print('Average page count: ' + averagePages.toStringAsFixed(1));

  final Book oldestBook = books.reduce((Book currentOldest, Book b) {
    final int yearA = currentOldest['year'] as int? ?? 0;
    final int yearB = b['year'] as int? ?? 0;
    return (yearB < yearA) ? b : currentOldest;
  });

  final Book newestBook = books.reduce((Book currentNewest, Book b) {
    final int yearA = currentNewest['year'] as int? ?? 0;
    final int yearB = b['year'] as int? ?? 0;
    return (yearB > yearA) ? b : currentNewest;
  });
  print('Oldest book: "${oldestBook['title']}" (${oldestBook['year']})');
  print('Newest book: "${newestBook['title']}" (${newestBook['year']})');

  final Book thickestBook = books.reduce((Book currentThickest, Book b) {
    final int pagesA = currentThickest['pages'] as int? ?? 0;
    final int pagesB = b['pages'] as int? ?? 0;
    return (pagesB > pagesA) ? b : currentThickest;
  });
  print('Thickest book: "${thickestBook['title']}" (${thickestBook['pages']} pages)');

  final Set<String> uniqueGenres = books.map((Book b) => (b['genre'] as String? ?? 'unknown')).toSet();
  print('Unique genres list: $uniqueGenres');

  final Map<String, int> genreCounts = {};
  for (String genre in uniqueGenres) {
    final int count = books.where((Book b) => b['genre'] == genre).length;
    genreCounts[genre] = count;
  }
  print('Books per genre: $genreCounts');

  final double readPercentage = (readCount / totalBooks) * 100;
  print('Read ratio: ' + readPercentage.toStringAsFixed(1) + '%');
}

int askInt(String prompt, {int min = 0, int? max}) {
  int? value;
  do {
    stdout.write('$prompt: ');
    value = int.tryParse(stdin.readLineSync() ?? '');
    if (value == null || value < min || (max != null && value > max)) {
      print('Incorrect value. Expected integer number' + 
            '${max == null ? " not less than $min" : " from $min to $max"}.');
      value = null;
    }
  } while (value == null);
  return value;
}

void addNewBook() {
  print('\n--- Adding New Book ---');
  stdout.write('Enter title: ');
  final String title = stdin.readLineSync() ?? 'Untitled';

  stdout.write('Enter author: ');
  final String author = stdin.readLineSync() ?? 'Unknown';

  final int year = askInt('Enter publication year', min: 1000, max: 2026);
  final int pages = askInt('Enter number of pages', min: 1);

  stdout.write('Enter genre: ');
  final String genre = (stdin.readLineSync() ?? 'unknown').trim().toLowerCase();

  stdout.write('Is it read? (yes/no): ');
  final String readAns = (stdin.readLineSync() ?? '').toLowerCase().trim();
  final bool isRead = (readAns == 'yes' || readAns == 'y');

  final Book newBook = {
    'title': title,
    'author': author,
    'year': year,
    'pages': pages,
    'genre': genre,
    'read': isRead
  };

  library.add(newBook);
  print('Success! Book added.');
}

void deleteBook() {
  print('\n--- Deleting Book ---');
  if (library.isEmpty) {
    print('Library is empty.');
    return;
  }

  final int indexToDel = askInt('Enter book number to delete', min: 1, max: library.length) - 1;
  final Book targetBook = library[indexToDel];

  stdout.write('Are you sure you want to delete "${targetBook['title']}"? (yes/no): ');
  final String confirm = (stdin.readLineSync() ?? '').toLowerCase().trim();

  if (confirm == 'yes' || confirm == 'y') {
    library.removeAt(indexToDel);
    print('Book successfully deleted.');
  } else {
    print('Deletion canceled.');
  }
}

List<Book> filter(List<Book> books, BookPredicate test) {
  final List<Book> output = [];
  for (Book b in books) {
    if (test(b) == true) {
      output.add(b);
    }
}
return output;
}
void runCustomFiltersDemo() {
  print('\n--- Custom Filters Demo (Higher-Order Functions) ---');
  print('\n1. Thick books (> 400 pages):');
  final List<Book> thickBooks = filter(library, (Book b) {
    final int p = b['pages'] as int? ?? 0;
    return p > 400;
  });
  printAll(thickBooks);

  print('\n2. New century books (>= year 2000):');
  final List<Book> newCenturyBooks = filter(library, (Book b) {
    final int y = b['year'] as int? ?? 0;
    return y >= 2000;
  });
  printAll(newCenturyBooks);

  print('\n3. Unread fantasy books:');
  final List<Book> unreadFantasy = filter(library, (Book b) {
    return b['genre'] == 'fantasy' && b['read'] == false;
  });
  printAll(unreadFantasy);
}


