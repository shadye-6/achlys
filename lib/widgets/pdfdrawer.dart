import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';

class PdfViewerDrawer extends StatelessWidget {
  final bool autoScroll;
  final double scrollSpeed;
  final ValueChanged<bool> onToggleAutoScroll;
  final ValueChanged<double> onScrollSpeedChanged;
  final String filePath;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const PdfViewerDrawer({
    super.key,
    required this.autoScroll,
    required this.scrollSpeed,
    required this.onToggleAutoScroll,
    required this.onScrollSpeedChanged,
    required this.filePath, 
    required this.isFavorite, 
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorThemes[0]['colorLight'],
      child: ListView(
        children: [
          SizedBox(height: 50,),
          ListTile(
            title: Text(isFavorite ? "Remove from Favorites" : "Add to Favorites"),
            trailing: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,),
            iconColor: colorThemes[0]['colorDark'],
            hoverColor: colorThemes[0]['colorMed'],
            splashColor: colorThemes[0]['colorMed'],
            onTap: onToggleFavorite,
          ),
          SwitchListTile(
            trackOutlineColor:WidgetStatePropertyAll(colorThemes[0]['colorDark']),
            inactiveTrackColor: colorThemes[0]['colorMed'],
            inactiveThumbColor: colorThemes[0]['colorDark'],
            activeTrackColor: colorThemes[0]['colorDark'],
            hoverColor: colorThemes[0]['colorMed'],
            title: Text("Auto Scroll", style: TextStyle(color: colorThemes[0]['colorDark']),),
            value: autoScroll,
            onChanged: onToggleAutoScroll,
          ),
          ListTile(
            title: Text("Scroll Speed", style: TextStyle(color: colorThemes[0]['colorDark']),),
            subtitle: Slider(
              inactiveColor: colorThemes[0]['colorMed'],
              value: scrollSpeed,
              onChanged: onScrollSpeedChanged,
              min: 1,
              max: 10,
              divisions: 9,
              label: "${scrollSpeed.toStringAsFixed(1)} px/tick",
              activeColor: colorThemes[0]['colorDark'],
            ),
          ),
        ],
      ),
    );
  }
}

