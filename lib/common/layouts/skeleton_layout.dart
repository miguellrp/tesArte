import 'package:go_router/go_router.dart';
import 'package:tesArte/app_config/app_config.dart';
import 'package:tesArte/common/components/TesArte_title_bar/tesArte_title_bar.dart';
import 'package:tesArte/common/components/generic/tesarte_text_icon_button.dart';
import 'package:tesArte/data/tesarte_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:tesArte/views/welcome_view/welcome_view.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            icon: Icons.cleaning_services,
            onPressed: () {
              TesArteSession.instance.endSession();
              TesArteDBHelper.restoreTesArteDatabase();
              context.go(WelcomeView.route);
            }
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
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                widget.content,
                if (AppConfig.developmentMode) Positioned(top: 0, right: 0, child: getTesArteDevTools())
              ],
            )
          ),
        ],
      ),
    );
  }
}
