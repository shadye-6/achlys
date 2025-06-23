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
  Map<String, bool> expandedShelves = {}; 

  @override
  void initState() {
    super.initState();
    _loadShelves();
  }

  Future<void> _loadShelves() async {
    final shelves = await loadShelvesFromPrefs();
    setState(() {
      shelfList = shelves;
      for (var shelf in shelves) {
        expandedShelves[shelf] = true;
      }
    });
  }

  void _addShelf(String shelfName) async {
    if (!shelfList.contains(shelfName)) {
      final created = await createShelf(shelfName);
      if (created) {
        setState(() {
          shelfList.add(shelfName);
          expandedShelves[shelfName] = true;
        });
        await saveShelves(shelfList);
      }
    }
  }

  void _deleteShelf(String shelfName) async {
    await deleteShelf(shelfName);
    setState(() {
      shelfList.remove(shelfName);
      expandedShelves.remove(shelfName);
    });
    await saveShelves(shelfList);
  }

  void _renameShelf(String oldName, String newName) async {
    try {
      await renameShelf(oldName, newName);
      setState(() {
        final index = shelfList.indexOf(oldName);
        if (index != -1) {
          shelfList[index] = newName;
          expandedShelves[newName] = expandedShelves[oldName] ?? true;
          expandedShelves.remove(oldName);
        }
      });
      await saveShelves(shelfList);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _reorderShelves(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      final shelf = shelfList.removeAt(oldIndex);
      shelfList.insert(newIndex, shelf);
    });
    await saveShelves(shelfList);
  }

  void _toggleShelf(String shelf) {
    setState(() {
      expandedShelves[shelf] = !(expandedShelves[shelf] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: colorThemes[0]['colorLight'],
        body: Column(
          children: [
            SafeArea(child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SearchBarBlank())),
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
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Tooltip(
                                  message: shelf,
                                  child: Text(
                                    shelf,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: colorThemes[0]['colorDark']),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add, color: colorThemes[0]['colorDark']),
                                    onPressed: () async {
                                      await pickAndAddPdfToShelf(shelf);
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.more_vert, color: colorThemes[0]['colorDark']),
                                    onPressed: () {
                                      showShelfOptionsDialog(
                                        context,
                                        currentShelfName: shelf,
                                        onRename: (newName) => _renameShelf(shelf, newName),
                                        onDelete: () => _deleteShelf(shelf),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      expandedShelves[shelf] == true
                                          ? Icons.arrow_right
                                          : Icons.arrow_drop_down,
                                      color: colorThemes[0]['colorDark'],
                                    ),
                                    onPressed: () => _toggleShelf(shelf),
                                  )
                                ],
                              ),
                            ],
                          ),
        
              
                          if (expandedShelves[shelf] == true)
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
                                  if (!snapshot.hasData) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
        
                                  final pdfs = snapshot.data!;
                                  if (pdfs.isEmpty) {
                                    return Center(
                                      child: Text(
                                        "No PDFs yet",
                                        style: TextStyle(color: colorThemes[0]['colorDark']),
                                      ),
                                    );
                                  }
        
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: pdfs.length,
                                    itemBuilder: (context, index) {
                                      return PdfCard(
                                        file: pdfs[index],
                                        onEdit: () {
                                          // handle edit
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
