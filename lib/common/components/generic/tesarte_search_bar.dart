import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);

class TesArteSearchBar extends StatelessWidget {
  final StringCallback onSearch;
  final Widget? leading;

  final double maxWidth;
  final double maxHeight;

  const TesArteSearchBar({
    super.key,
    required this.onSearch,
    this.leading,

    this.maxWidth = 350,
    this.maxHeight = 1650,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 7, vertical: 5)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary.withAlpha(100)),
      textStyle: WidgetStatePropertyAll(TextStyle(color: Theme.of(context).colorScheme.tertiary)),
      elevation: WidgetStatePropertyAll(2),
      
      leading: leading??Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary.withAlpha(70)),
      
      onSubmitted: (value) => onSearch(value),
    );
  }
}
