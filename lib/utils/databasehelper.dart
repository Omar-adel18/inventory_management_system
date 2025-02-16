import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton Pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  // The DatabaseHelper._internal() is calling the private constructor of DatabaseHelper
  DatabaseHelper._internal();

  // The get database function checks if _database is already initialized. If so, it simply returns the existing instance.
  // If _database is null, it calls _initDatabase() to initialize the database and assign it to _database,
  // then returns the database instance.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '5.db'); // Ensure the path is correct
    // final path = join(dbPath, 'inventory.db'); // Ensure the path is correct
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON;');

        // Create Categories table
        await db.execute('''
          CREATE TABLE Categories (
            CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,
            Name TEXT NOT NULL UNIQUE
          )
        ''');
        // Create Products table
        await db.execute('''
          CREATE TABLE Products (
            ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
            Name TEXT NOT NULL,
            Description TEXT NOT NULL,
            Price REAL NOT NULL,
            StockQuantity INTEGER NOT NULL,
            CategoryID INTEGER NOT NULL,
            FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID) ON DELETE CASCADE
          )
        ''');
        //// Create Customers table
        await db.execute('''
          CREATE TABLE Customers (
            CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
            CustomerName TEXT NOT NULL,
            CustomerEmail TEXT NOT NULL,
            Street TEXT,
            Zone TEXT,
            City TEXT
          )
        ''');
        // Create Orders table
        await db.execute('''
          CREATE TABLE Orders (
            OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
            OrderDate TEXT NOT NULL,
            CustomerID INTEGER NOT NULL,
            FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ON DELETE CASCADE
          )
        ''');
        // Create OrderItem table
        await db.execute('''
          CREATE TABLE OrderItem (
            OrderItemID INTEGER PRIMARY KEY AUTOINCREMENT,
            ProductID INTEGER NOT NULL,
            OrderID INTEGER NOT NULL,
            Quantity INTEGER NOT NULL,
            FOREIGN KEY (ProductID) REFERENCES Products (ProductID) ON DELETE CASCADE,
            FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ON DELETE CASCADE
          )
        ''');
      },
      onOpen: (db) async {
        // Ensure foreign keys are enabled every time the database is opened
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }

  Future<void> deleteAllRows() async {
    final db = await database;

    // Disable foreign key constraints temporarily
    await db.execute('PRAGMA foreign_keys = OFF');

    try {
      // Delete all rows from each table
      await db.delete('OrderItem');
      await db.delete('Orders');
      await db.delete('Customers');
      await db.delete('Products');
      await db.delete('Categories');
      print('All rows deleted successfully!');
    } catch (e) {
      print('Failed to delete rows: $e');
    } finally {
      // Re-enable foreign key constraints
      await db.execute('PRAGMA foreign_keys = ON');
    }
  }

  Future<String?> getCategoryNameByProductName(String productName) async {
    final db = await database;
    // Query the Products table to get products that match the given category
    final result = await db.rawQuery(
      '''
            SELECT Categories.Name AS CategoryName
            FROM Products
            JOIN Categories ON Products.CategoryID = Categories.CategoryID
            WHERE Products.Name = ?
            ''',
      [productName],
    );
    if (result.isNotEmpty) {
      return result.first['CategoryName'] as String?;
    } else {
      return null; // Return null if no matching product is found
    }
  }

  Future<bool> customerExists(int customerId) async {
    final db = await database;
    var result = await db.query(
      'Customers', // Replace with your actual customer table name
      where: 'CustomerID = ?',
      // Replace with your actual customer ID column name
      whereArgs: [customerId],
    );
    return result.isNotEmpty;
  }

  Future<int> addOrderItem({
    required int orderId,
    required int productId,
    required int quantity,
  }) async {
    final db = await database;
    final data = {
      'OrderID': orderId,
      'ProductID': productId,
      'Quantity': quantity,
    };
    return await db.insert(
      'OrderItem',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addCategory({required String name}) async {
    final db = await database;
    final data = {'Name': name};
    return await db.insert(
      'Categories',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> retrieveCategories() async {
    final db = await database;
    return await db.query('Categories');
  }

  Future<int> updateCategory(
      {required int categoryId, required String updatedName}) async {
    final dp = await database;
    final data = {'Name': updatedName};
    return await dp.update(
      'Categories',
      data,
      where: 'categoryID = ?',
      whereArgs: [categoryId],
    );
  }

  Future<int> deleteCategory(int categoryId) async {
    final dp = await database;
    return await dp.delete(
      'Categories',
      where: 'categoryID = ?',
      whereArgs: [categoryId],
    );
  }

  // Products Table Methods
  Future<int> addProduct({
    required String name,
    required String description,
    required double price,
    required int stockQuantity,
    required int categoryId,
  }) async {
    final db = await database;
    final data = {
      'Name': name,
      'Description': description,
      'Price': price,
      'StockQuantity': stockQuantity,
      'CategoryID': categoryId
    };
    return await db.insert(
      'Products',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getProductID(String productName) async {
    final dp = await database;
    final result =
        await dp.query('Products', where: 'Name = ?', whereArgs: [productName]);

    if (result.isNotEmpty) {
      return result.first['ProductID'] as int;
    } else {
      throw Exception('Product not found: $productName');
    }
  }

  Future<int> getProductStockQuantity(int productId) async {
    final dp = await database;
    try {
      final result = await dp.query(
        'Products',
        columns: ['StockQuantity'],
        where: 'ProductID = ?',
        whereArgs: [productId],
      );

      if (result.isNotEmpty) {
        final stockQuantity = result.first['StockQuantity'];
        if (stockQuantity != null) {
          return stockQuantity as int; // Safe cast
        } else {
          log('StockQuantity is null for product ID: $productId');
          throw Exception('StockQuantity is null for product ID: $productId');
        }
      } else {
        log('Product not found for ID: $productId');
        throw Exception('Product not found for ID: $productId');
      }
    } catch (e) {
      log('Error retrieving stock quantity for product ID $productId: $e');
      throw Exception(
          'Error retrieving stock quantity for product ID $productId: $e');
    }
  }

  Future<int> updateProduct({
    required int productID,
    required String name,
    required String description,
    required double price,
    required int stockQuantity,
  }) async {
    final db = await database;
    final data = {
      'Name': name,
      'Description': description,
      'Price': price,
      'StockQuantity': stockQuantity,
    };
    return await db.update(
      'Products', // Table name
      data, // Data to update
      where: 'ProductID = ?', // Condition
      whereArgs: [productID], // Arguments for the condition
    );
  }

  Future<List<Map<String, dynamic>>> retrieveProducts(
      {required int categoryId}) async {
    final db = await database;
    return await db.query(
      'Products',
      where: 'CategoryID = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<Map<String, dynamic>>> retrieveProductsByCategory(
      String categoryName) async {
    final db = await database;
    // Query the Products table to get products that match the given category
    return await db.rawQuery('''
      SELECT p.* FROM Products p
      JOIN Categories c ON p.CategoryID = c.CategoryID
      WHERE c.Name = ?
    ''', [categoryName]);
  }

  Future<int> deleteProduct(int productId) async {
    final db = await database;
    return await db.delete(
      'Products',
      where: 'ProductID = ?',
      whereArgs: [productId],
    );
  }

  Future<int> addCustomer({
    required String name,
    required String email,
    required String street,
    required String zone,
    required String city,
  }) async {
    final db =
        await database; // Assumes `database` is the initialized SQLite instance
    final data = {
      'CustomerName': name,
      'CustomerEmail': email,
      'Street': street,
      'Zone': zone,
      'City': city,
    };
    return await db.insert('Customers', data);
  }

  Future<List<Map<String, dynamic>>> retrieveCustomers() async {
    final db = await database;
    return await db.query('Customers');
  }

  Future<int> updateCustomer({
    required int customerID,
    required String name,
    required String email,
    required String street,
    required String zone,
    required String city,
  }) async {
    final db = await database; // Get the database instance
    final data = {
      'CustomerName': name,
      'CustomerEmail': email,
      'Street': street,
      'Zone': zone,
      'City': city,
    };
    return await db.update(
      'Customers', // Table name
      data, // Data to update
      where: 'CustomerID = ?', // Condition
      whereArgs: [customerID], // Arguments for the condition
    );
  }

  Future<int> deleteCustomer({
    required int customerID,
  }) async {
    final db = await database; // Get the database instance
    return await db.delete(
      'Customers', // Table name
      where: 'CustomerID = ?', // Condition
      whereArgs: [customerID], // Arguments for the condition
    );
  }

  Future<int> addOrder({
    required int customerId,
    required String orderDate,
  }) async {
    final db =
        await database; // Assumes `database` is the initialized SQLite instance
    final data = {
      'CustomerID': customerId,
      'OrderDate': orderDate,
    };
    return await db.insert('Orders', data);
  }

  Future<List<Map<String, dynamic>>> retrieveAllOrders() async {
    final db = await database;

    // Query to fetch orders along with order items and product details
    final orders = await db.rawQuery('''
    SELECT 
      o.OrderID AS orderID, 
      o.OrderDate AS orderDate, 
      c.CustomerName AS customerName,
      c.CustomerEmail AS customerEmail,
      oi.ProductID AS productID, 
      p.Name AS productName, 
      p.Description AS productDescription, 
      p.Price AS price, 
      oi.Quantity AS quantity
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN OrderItem oi ON o.OrderID = oi.OrderID
    JOIN Products p ON oi.ProductID = p.ProductID
    ORDER BY o.OrderDate DESC
  ''');

    // Group the data by orders
    final Map<int, Map<String, dynamic>> groupedOrders = {};

    for (var row in orders) {
      final orderID = row['orderID'] as int;
      if (!groupedOrders.containsKey(orderID)) {
        groupedOrders[orderID] = {
          'order': {
            'id': orderID,
            'orderDate': row['orderDate'],
            'customerName': row['customerName'],
            'customerEmail': row['customerEmail'],
          },
          'items': [],
        };
      }

      // Add the order item details
      groupedOrders[orderID]!['items']!.add({
        'productName': row['productName'],
        'productDescription': row['productDescription'],
        'price': row['price'],
        'quantity': row['quantity'],
      });
    }

    // Convert the grouped map into a list
    return groupedOrders.values.toList();
  }

  Future<List<Map<String, dynamic>>> getRecentOrdersPerCustomer(
      int customerID) async {
    final db = await database;
    final List<Map<String, dynamic>> recentOrders = await db.rawQuery('''
    SELECT o.OrderID, o.OrderDate, oi.ProductID, p.Name AS ProductName, oi.Quantity, p.Price, 
           (oi.Quantity * p.Price) AS TotalPrice
    FROM Orders o
    JOIN OrderItem oi ON o.OrderID = oi.OrderID
    JOIN Products p ON oi.ProductID = p.ProductID
    WHERE o.CustomerID = ?
    ORDER BY o.OrderDate DESC
    LIMIT 5;  -- Adjust the limit if you need more or fewer recent orders
  ''', [customerID]);

    return recentOrders;
  }

  Future<List<Map<String, dynamic>>> getRecentOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT Orders.OrderID, Orders.OrderDate, Customers.CustomerName 
    FROM Orders 
    JOIN Customers ON Orders.CustomerID = Customers.CustomerID 
    ORDER BY Orders.OrderDate DESC 
    LIMIT 5
  '''); // Fetch the latest 5 orders
    return result;
  }

  Future<int> getTotalOrders() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(OrderID) AS count FROM Orders');
    return result.first['count'] as int;
  }

  Future<int> getTotalItemsSold() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(Quantity) AS total FROM OrderItem');
    return result.first['total'] as int? ?? 0;
  }

  Future<List<Map<String, dynamic>>> getTopSellingProducts() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT Products.ProductID, Products.Name, SUM(OrderItem.Quantity) AS totalSold 
    FROM OrderItem 
    JOIN Products ON OrderItem.ProductID = Products.ProductID 
    GROUP BY Products.ProductID 
    ORDER BY totalSold DESC 
    LIMIT 5
  ''');
  }

  Future<List<Map<String, dynamic>>> getOrdersPerDay() async {
    final db = await database;

    // SQLite Query: Ensures all days are included, even if there are no orders
    final result = await db.rawQuery('''
    WITH RECURSIVE Last15Days AS (
      SELECT date('now', '-14 days') AS OrderDate
      UNION ALL
      SELECT date(OrderDate, '+1 day') FROM Last15Days WHERE OrderDate < date('now')
    )
    SELECT Last15Days.OrderDate, 
           COUNT(Orders.OrderID) AS totalOrders 
    FROM Last15Days
    LEFT JOIN Orders ON date(Orders.OrderDate) = Last15Days.OrderDate
    GROUP BY Last15Days.OrderDate
    ORDER BY Last15Days.OrderDate;
  ''');
    return result;
  }

  Future<Map<String, int>> getOrdersAndItemsLastMonth() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      COUNT(DISTINCT o.OrderID) AS totalOrders,
      COUNT(oi.OrderItemID) AS totalOrderItems
    FROM Orders o
    LEFT JOIN OrderItem oi ON o.OrderID = oi.OrderID
    WHERE strftime('%Y-%m', o.OrderDate) = strftime('%Y-%m', 'now');
  ''');

    return {
      'totalOrders': result[0]['totalOrders'] as int,
      'totalOrderItems': result[0]['totalOrderItems'] as int,
    };
  }

  Future<List<Map<String, dynamic>>> getProductsPerCategoryInOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
        Categories.Name AS CategoryName,
        COUNT(DISTINCT Products.ProductID) AS ProductCount
    FROM 
        OrderItem
    JOIN 
        Products ON OrderItem.ProductID = Products.ProductID
    JOIN 
        Categories ON Products.CategoryID = Categories.CategoryID
    GROUP BY 
        Categories.Name;
  ''');

    return result;
  }

  Future<int> deleteOrder(int orderId) async {
    final db = await database;
    int rowDeleted = await db.delete(
      'Orders',
      where: 'OrderID = ?',
      whereArgs: [orderId],
    );
    return rowDeleted;
  }

  Future<double> getTotalSpend(int customerID) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT SUM(oi.Quantity * p.Price) AS TotalSpend
    FROM Orders o
    JOIN OrderItem oi ON o.OrderID = oi.OrderID
    JOIN Products p ON oi.ProductID = p.ProductID
    WHERE o.CustomerID = ?
  ''', [customerID]);

    // If the result is empty, return 0.0
    return result.isNotEmpty ? result.first['TotalSpend'] ?? 0.0 : 0.0;
  }

  Future<List<Map<String, dynamic>>> getTop5ProductsByOrderQuantity() async {
    final db = await database;

    // Execute the SQL query
    final result = await db.rawQuery('''
    SELECT 
      Name, 
      COALESCE(SUM(Quantity), 0) AS TotalQuantity
    FROM 
      OrderItem 
    JOIN 
      Products ON OrderItem.ProductID = Products.ProductID
    GROUP BY 
      Name
    ORDER BY 
      TotalQuantity DESC
    LIMIT 5;
  ''');

    return result;
  }

  void printDatabasePath() async {
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/my_database.db';
      log('Database path: $path');
    } else {
      log('This platform is not supported.');
    }
  }
}
