import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
	static Database _database;                // Singleton Database

	String tblUsers = 'users';

	DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

	factory DatabaseHelper() {
		if (_databaseHelper == null) _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		return _databaseHelper;
	}

	Future<Database> get database async {
		if (_database == null) _database = await initializeDatabase();
		return _database;
	}

	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'cashless.db';
		// Open/create the database at a given path
		var dbCashless = await openDatabase(path, version: 1, onCreate: _createDb);
		return dbCashless;
	}

	void _createDb(Database db, int newVersion) async {
		await db.execute(
			'CREATE TABLE $tblUsers ('
			'  id INTEGER PRIMARY KEY AUTOINCREMENT,'
			'  phone 		 TEXT,'
			'  studentId TEXT,'
			'  name 		 TEXT,'
			'  email 		 TEXT,'
			'  password 		 TEXT,'
			'  pin 			 TEXT,'
			'  date 		 TEXT,'
			'  confirm 	       INTEGER'
			');'
		);
	}

}
