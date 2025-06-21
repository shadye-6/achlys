import 'dart:io';

import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/functions/pdfs.dart';
import 'package:achlys/functions/shelves.dart';
import 'package:achlys/widgets/createshelfbox.dart';
import 'package:achlys/widgets/editshelfbox.dart';
import 'package:achlys/widgets/pdfcard.dart';
import 'package:achlys/widgets/searchbar.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<String> shelfList = [];

  @override
  //loading upon revisiting
  void initState() {
    super.initState();
    _loadShelves();
  }

  //locally loading
  Future<void> _loadShelves() async {
    final shelves = await loadShelvesFromPrefs();
    setState(() => shelfList = shelves);
  }

  //locally adding
  void _addShelf(String shelfName) async {
    if (!shelfList.contains(shelfName)) {
      final created = await createShelf(shelfName);
      if (created) {
        setState(() {
          shelfList.add(shelfName);
        });
        await saveShelves(shelfList);
      }
    }
  }

  //locally delete
  void _deleteShelf(String shelfName) async {
    await deleteShelf(shelfName); 
    setState(() {
      shelfList.remove(shelfName); 
    });
    await saveShelves(shelfList); 
  }

  //locally rename
  void _renameShelf(String oldName, String newName) async {
    try {
      await renameShelf(oldName, newName);
      setState(() {
        final index = shelfList.indexOf(oldName);
        if (index != -1) {
          shelfList[index] = newName;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  //locally reordering
  void _reorderShelves(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      final shelf = shelfList.removeAt(oldIndex);
      shelfList.insert(newIndex, shelf);
    });
    await saveShelves(shelfList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorThemes[0]['colorLight'],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarBlank(),
            ),
            ElevatedButton.icon(
              onPressed: () => showCreateShelfDialog(context, onShelfCreated: _addShelf),
              label: Text("Create New Shelf", style: TextStyle(color: colorThemes[0]['colorLight'])),
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorThemes[0]['colorDark'],
                foregroundColor: colorThemes[0]['colorLight'],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.all(12),
                onReorder: _reorderShelves,
                children: [
                  for (final shelf in shelfList)
                    Container(
                      key: ValueKey(shelf),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Tooltip(
                                  message: shelf,
                                  child: Text(
                                    shelf,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () async {
                                      await pickAndAddPdfToShelf(shelf);
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      showShelfOptionsDialog(
                                        context,
                                        currentShelfName: shelf,
                                        onRename: (newName) => _renameShelf(shelf, newName),
                                        onDelete: () => _deleteShelf(shelf),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: colorThemes[0]['colorMed'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: FutureBuilder<List<FileSystemEntity>>(
                              future: getPdfsInShelf(shelf),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                                final pdfs = snapshot.data!;
                                if (pdfs.isEmpty) {
                                  return const Center(child: Text("No PDFs yet"));
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pdfs.length,
                                  itemBuilder: (context, index) {
                                    return PdfCard(
                                      file: pdfs[index],
                                      onEdit: () {
                                        //for renaming pdf / adding custom image cover
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
