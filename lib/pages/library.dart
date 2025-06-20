import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/functions/shelves.dart';
import 'package:achlys/widgets/createshelfbox.dart';
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
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: colorThemes[0]['colorMed'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(child: Text(shelf),),
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
