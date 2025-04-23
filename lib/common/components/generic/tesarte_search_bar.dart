import 'package:flutter/material.dart';
import 'package:tesArte/common/components/generic/tesarte_icon_button.dart';

typedef StringCallback = void Function(String);

class TesArteSearchBar extends StatefulWidget {
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
  State<TesArteSearchBar> createState() => _TesArteSearchBarState();
}

class _TesArteSearchBarState extends State<TesArteSearchBar> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      focusNode: focusNode,
      constraints: BoxConstraints(maxWidth: widget.maxWidth, maxHeight: widget.maxHeight),
      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 7, vertical: 5)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary.withAlpha(100)),
      textStyle: WidgetStatePropertyAll(TextStyle(color: Theme.of(context).colorScheme.tertiary)),
      elevation: WidgetStatePropertyAll(2),
      
      leading: widget.leading??Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary.withAlpha(70)),
      trailing: [
        TesArteIconButton(icon: Icon(Icons.close), color: Theme.of(context).colorScheme.tertiary.withAlpha(100),
          onPressed: () {
            controller.clear();
            focusNode.requestFocus();
          }
        )
      ],
      
      onSubmitted: (value) => widget.onSearch(value),
    );
  }
}
