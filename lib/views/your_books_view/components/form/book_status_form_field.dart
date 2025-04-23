import 'package:flutter/material.dart';
import 'package:tesArte/app_config/router.dart';
import 'package:tesArte/views/your_books_view/util_book.dart';

class BookStatusFormField extends StatefulWidget {
  final int? initialSelection;
  final ValueChanged<int?>? onChanged;

  const BookStatusFormField({
    super.key,
    this.initialSelection,
    this.onChanged,
  });

  @override
  State<BookStatusFormField> createState() => _BookStatusFormFieldState();
}

class _BookStatusFormFieldState extends State<BookStatusFormField> {
  late int selectedValue;
  late final Text labelText;
  late final Color labelColor;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialSelection ?? 0;

    labelColor = Theme.of(navigatorKey.currentContext!).colorScheme.onPrimary.withAlpha(160);

    labelText = Text("Estado da lectura:", // TODO: lang
      style: Theme.of(navigatorKey.currentContext!).textTheme.labelLarge!.copyWith(color: labelColor),
    );
  }

  List<DropdownMenuItem<int>> _getStatusItems() {
    List<DropdownMenuItem<int>> statusItems = [];
    final TextStyle textStyle = TextTheme.of(navigatorKey.currentContext!).labelLarge!.copyWith(fontSize: 17);

    for (int status = 0; status < 3; status++) {
      statusItems.add(
        DropdownMenuItem(
          value: status,
          child: Center(
            child: Text(UtilBook.getStatusText(status),
              style: textStyle.copyWith(color: UtilBook.getStatusColor(status)))
          )
        )
      );
    }

    return statusItems;
  }



  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 5,
      children: [
        labelText,
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: labelColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              items: _getStatusItems(),
              value: selectedValue,
              onChanged: (int? newValue) {
                setState(() => selectedValue = newValue!);

                if (widget.onChanged != null) widget.onChanged!(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}