import 'package:tesArte/app_config/app_config.dart';
import 'package:tesArte/common/components/TesArte_title_bar/tesArte_title_bar.dart';
import 'package:tesArte/common/components/tesarte_text_icon_button.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:flutter/material.dart';

class SkeletonLayout extends StatefulWidget {
  final Widget content;
  const SkeletonLayout({super.key, required this.content});

  @override
  State<SkeletonLayout> createState() => _SkeletonLayoutState();
}

class _SkeletonLayoutState extends State<SkeletonLayout> {
  Container getTesArteDevTools() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: 350,
      height: 50,
      color: Theme.of(context).colorScheme.primary.withAlpha(150),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          Text("DevMode", style: TextTheme.of(context).labelSmall!.copyWith(color: Colors.white),),
          TesArteTextIconButton(
            text: "restore database",
            iconData: Icons.cleaning_services,
            onPressed: () => TesArteDBHelper.restoreTesArteDatabase()
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TesArteTitleBar(),
          Expanded(child:
            Stack(
              alignment: Alignment.topCenter,
              children: [
                widget.content,
                if (AppConfig.developmentMode) Positioned(bottom: 0, child: getTesArteDevTools())
              ],
            )
          ),
        ],
      ),
    );
  }
}
