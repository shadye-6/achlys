import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String shelfKey = 'shelf_list';

// Returns the base directory where all shelves are stored
Future<Directory> getShelvesBaseDir() async {
  final baseDir = await getApplicationDocumentsDirectory();
  final shelvesDir = Directory('${baseDir.path}/shelves');
  if (!await shelvesDir.exists()) {
    await shelvesDir.create(recursive: true);
  }
  return shelvesDir;
}

// Creates a shelf (folder) with the given name if it doesn't already exist
Future<bool> createShelf(String shelfName) async {
  final shelvesDir = await getShelvesBaseDir();
  final newShelf = Directory('${shelvesDir.path}/$shelfName');
  if (!await newShelf.exists()) {
    await newShelf.create();
    return true;
  }
  return false;
}

// Deletes the specified shelf (folder)
Future<void> deleteShelf(String shelfName) async {
  final shelvesDir = await getShelvesBaseDir();
  final shelf = Directory('${shelvesDir.path}/$shelfName');
  if (await shelf.exists()) {
    await shelf.delete(recursive: true);
  }
}

// Lists all shelf folder names stored in the shelves directory
Future<List<String>> listShelves() async {
  final shelvesDir = await getShelvesBaseDir();
  final items = shelvesDir.listSync();
  return items
      .whereType<Directory>()
      .map((dir) => dir.path.split('/').last)
      .toList();
}

// Saves the list of shelf names to shared preferences
Future<void> saveShelves(List<String> shelves) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(shelfKey, shelves);
}

// Loads the list of shelf names from shared preferences
Future<List<String>> loadShelvesFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(shelfKey) ?? [];
}
