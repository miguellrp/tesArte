import 'package:flutter/material.dart';
import 'package:tesArte/book/ui/ui_models/ui_book.dart';
import 'package:tesArte/common/placeholders/book_placeholder/book_placeholder_painter.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_mask_painter.dart';


final double bookPlaceholderWidth = UIBook.bookCoverMiniatureWidth;
final double bookPlaceholderHeight = UIBook.bookCoverMiniatureHeight;

class BookPlaceholder extends StatelessWidget {
  Color? color;
  BookPlaceholder({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        CustomPaint(
          painter: BookPlaceholderPainter(color: color!),
          size: Size(bookPlaceholderWidth, bookPlaceholderHeight),
        ),
        Positioned(
          top: (1 - 0.55) * bookPlaceholderHeight,
          right: (1 - 0.72) * bookPlaceholderWidth,
          child: CustomPaint(
            painter: TesArteMaskPainter(color: Theme.of(context).colorScheme.secondary),
            size: Size(bookPlaceholderWidth / 2.2, bookPlaceholderHeight / 3),
          ),
        ),

      ],
    );
  }
}
