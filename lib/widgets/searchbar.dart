import 'package:achlys/colorThemes/colors.dart';
import 'package:flutter/material.dart';

class SearchBarBlank extends StatelessWidget {
  const SearchBarBlank({super.key});

  @override
  Widget build(BuildContext context) {
    return Material( 
      child: SearchAnchor.bar(
        barBackgroundColor: WidgetStatePropertyAll(colorThemes[0]['colorMed']),
        viewBackgroundColor: colorThemes[0]['colorMed'],
        dividerColor: colorThemes[0]['colorLight'],
        barHintText: 'Search',
        barHintStyle: WidgetStatePropertyAll(TextStyle(color: colorThemes[0]['colorLight'])),
        barTextStyle: WidgetStatePropertyAll(
          TextStyle(color: colorThemes[0]['colorLight'])
        ),
        suggestionsBuilder: (context, controller) {
          return [];
        },
      ),
    );
  }
}
