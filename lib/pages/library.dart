import 'package:achlys/colorThemes/colors.dart';
import 'package:achlys/widgets/createshelfbox.dart';
import 'package:achlys/widgets/searchbar.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

  final List myShelves = ['1', '2', '3', '4'];

  void updateShelves(int oldIndex, int newIndex){
    setState(() {
      if (oldIndex < newIndex) newIndex--;

      final String shelf = myShelves.removeAt(oldIndex);
      myShelves.insert(newIndex, shelf);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorThemes[0]['colorLight'],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarBlank(),
          ),
          ElevatedButton.icon(
            onPressed: () => showCreateShelfDialog(context),
            label: Text(
              "Create New Shelf",
              style: TextStyle(color: colorThemes[0]['colorLight']),
            ),
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
              onReorder: (oldIndex, newIndex) {updateShelves(oldIndex, newIndex);},
              children: [
                for (final shelf in myShelves) 
                  Padding(
                    key: ValueKey(shelf),
                    padding: EdgeInsets.all(8),
                    child: Container(
                      color: colorThemes[0]['colorMed'],
                      height: 100,
                      width: double.infinity,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
