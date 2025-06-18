import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Directory> getShelvesBaseDir() async {
  final baseDir = await getApplicationDocumentsDirectory();
  final shelvesDir = Directory('${baseDir.path}/shelves');
  if (!await shelvesDir.exists()) {
    await shelvesDir.create(recursive: true);
  }
  return shelvesDir;
}

Future<bool> createShelf(String shelfName) async {
  final shelvesDir = await getShelvesBaseDir();
  final newShelf = Directory('${shelvesDir.path}/$shelfName');
  if (!await newShelf.exists()) {
    await newShelf.create();
    return true;
  }
  return false;
}

Future<bool> deleteShelf(String shelfName) async {
  final shelvesDir = await getShelvesBaseDir();
  final shelf = Directory('${shelvesDir.path}/$shelfName');
  if (await shelf.exists()) {
    await shelf.delete(recursive: true);
    return true;
  }
  return false;
}

Future<List<String>> listShelves() async {
  final shelvesDir = await getShelvesBaseDir();
  final dirs = shelvesDir.listSync();
  return dirs.whereType<Directory>().map((d) => d.path.split('/').last).toList();
}

