import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:flutter/material.dart';

enum TextFormFieldType {
  text,
  password,
  number
}

typedef StringCallback = String? Function(String?);
typedef VoidStringCallback = void Function(String?);

class TesArteTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextFormFieldType textFormFieldType;
  final StringCallback? validator;

  final bool bordered;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final double maxWidth;

  final VoidStringCallback? onChange;


  const TesArteTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.textFormFieldType = TextFormFieldType.text,
    this.validator,

    this.bordered = true,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.maxWidth = double.infinity,

    this.onChange
  });

  @override
  Widget build(BuildContext context) {
    InputBorder getInputBorder({errorInput = false, double width = 1, int alpha = 255}) {
      final Color borderColor = errorInput ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onPrimary;

      return bordered ? OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor.withAlpha(alpha),
          width: width
        ),
      ) : UnderlineInputBorder(
        borderSide: BorderSide(
          color: borderColor.withAlpha(alpha),
          width: width
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        keyboardType: textFormFieldType == TextFormFieldType.number ? TextInputType.number : TextInputType.text,
        onChanged: onChange != null ? (value) => onChange!(value) : null,
        validator: validator != null ? (value) => validator!(value) : null,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: textFormFieldType == TextFormFieldType.password,
        decoration: InputDecoration(
          labelText: labelText,
          alignLabelWithHint: true,
          labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
          ),
          hintText: hintText.isNotEmptyAndNotNull ? hintText : null,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(150),
            fontStyle: FontStyle.italic
          ),
          enabledBorder: getInputBorder(alpha: 150),
          focusedBorder: getInputBorder(width: 2),
          errorBorder: getInputBorder(errorInput: true),
          focusedErrorBorder: getInputBorder(errorInput: true),
        ),
      ),
    );
  }
}
