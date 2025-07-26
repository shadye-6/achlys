import 'dart:io';
import 'package:path/path.dart' as p; // Add this import
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String shelfKey = 'shelf_list';

// directory of shelf
Future<Directory> getShelvesBaseDir() async {
  final baseDir = await getApplicationDocumentsDirectory();
  final shelvesDir = Directory('${baseDir.path}/shelves');
  if (!await shelvesDir.exists()) {
    await shelvesDir.create(recursive: true);
  }
  return shelvesDir;
}

// creates unique shelf only
Future<bool> createShelf(String shelfName) async {
  final shelvesDir = await getShelvesBaseDir();
  final newShelf = Directory('${shelvesDir.path}/$shelfName');
  if (!await newShelf.exists()) {
    await newShelf.create();
    return true;
  }
  return false;
}

// delete the shelf
Future<void> deleteShelf(String shelfName) async {
  final shelvesDir = await getShelvesBaseDir();
  final shelf = Directory('${shelvesDir.path}/$shelfName');
  if (await shelf.exists()) {
    await shelf.delete(recursive: true);
  }
}

// list of all shelves
Future<List<String>> listShelves() async {
  final shelvesDir = await getShelvesBaseDir();
  final items = await shelvesDir.list().toList();
  return items
      .whereType<Directory>()
      .map((dir) => p.basename(dir.path)) // Use p.basename
      .toList();
}

//saves order of shelves
Future<void> saveShelves(List<String> shelves) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(shelfKey, shelves);
}

//gets the list of shelves
Future<List<String>> loadShelvesFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(shelfKey) ?? [];
}


//rename shelf
Future<void> renameShelf(String oldName, String newName) async {
  final baseDir = await getApplicationDocumentsDirectory();
  final oldShelf = Directory('${baseDir.path}/shelves/$oldName');
  final newShelf = Directory('${baseDir.path}/shelves/$newName');

  if (await newShelf.exists()) {
    throw Exception("A shelf with that name already exists.");
  }

  if (await oldShelf.exists()) {
    await oldShelf.rename(newShelf.path);
  }
  final prefs = await SharedPreferences.getInstance();
  final shelfList = prefs.getStringList(shelfKey) ?? [];
  final index = shelfList.indexOf(oldName);

  if (index != -1) {
    shelfList[index] = newName;
    await prefs.setStringList(shelfKey, shelfList);
  }
}
