import 'package:achlys/functions/shelves.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

//adds pdf to shelf
Future<void> pickAndAddPdfToShelf(String shelfName) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.single.path != null) {
    final sourcePath = result.files.single.path!;
    final fileName = sourcePath.split('/').last;

    final shelvesBaseDir = await getShelvesBaseDir();
    final shelfDir = Directory('${shelvesBaseDir.path}/$shelfName');

    if (!await shelfDir.exists()) {
      await shelfDir.create(recursive: true);
    }

    final destinationPath = '${shelfDir.path}/$fileName';
    await File(sourcePath).copy(destinationPath);
  }
}

//gets list of pdfs
Future<List<FileSystemEntity>> getPdfsInShelf(String shelfName) async {
  final dir = await getShelvesBaseDir();
  final shelf = Directory('${dir.path}/$shelfName');
  if (!await shelf.exists()) return [];
  return shelf.listSync().where((e) => e.path.endsWith('.pdf')).toList();
}
