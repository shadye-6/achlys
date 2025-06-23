import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';

class PdfViewerDrawer extends StatelessWidget {
  final bool autoScroll;
  final double scrollSpeed;
  final ValueChanged<bool> onToggleAutoScroll;
  final ValueChanged<double> onScrollSpeedChanged;

  const PdfViewerDrawer({
    super.key,
    required this.autoScroll,
    required this.scrollSpeed,
    required this.onToggleAutoScroll,
    required this.onScrollSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colorThemes[0]['colorLight'],
      child: ListView(
        children: [
          const DrawerHeader(child: Text("Options")),
          SwitchListTile(
            title: const Text("Auto Scroll"),
            value: autoScroll,
            onChanged: onToggleAutoScroll,
          ),
          ListTile(
            title: const Text("Scroll Speed"),
            subtitle: Slider(
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

