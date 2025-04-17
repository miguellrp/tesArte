import 'package:material_symbols_icons/symbols.dart';
import 'package:tesArte/common/components/tesarte_card.dart';
import 'package:tesArte/common/components/tesarte_divider.dart';
import 'package:tesArte/common/components/tesarte_toast.dart';
import 'package:tesArte/common/components/form/tesarte_text_form_field.dart';
import 'package:tesArte/common/components/tesarte_text_icon_button.dart';
import 'package:tesArte/common/placeholders/tesarte_loader/tesarte_loader.dart';
import 'package:tesArte/common/utils/tesarte_extensions.dart';
import 'package:tesArte/common/utils/tesarte_validator.dart';
import 'package:tesArte/common/utils/util_viewport.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
import 'package:tesArte/l10n/generated/app_localizations.dart';
import 'package:tesArte/models/tesarte_session/tesarte_session.dart';
import 'package:tesArte/models/user/user.dart';
import 'package:tesArte/views/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeView extends StatefulWidget {
  static const String route = "/";
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomeView> {
  final GlobalKey<FormState> _createUserFormKey = GlobalKey<FormState>();

  late bool isWideScreen;
  bool userInitialized = false;
  bool widgetsInitialized = false;
  bool existsLastLoggedUser = false;

  User? loggedUser;

  final TextEditingController usernameController = TextEditingController();

  TesArteTextFormField? usernameFormField;
  TesArteTextIconButton? continueButton;
  TesArteCard? welcomingCard;
  Form? createUserForm;

  @override
  void initState() {
    usernameFormField = TesArteTextFormField(
      controller: usernameController,
      hintText: "artisTeo",
      maxWidth: 350,
      bordered: false,
      validator: (value) => TesArteValidator.doValidation(type: TesArteValidatorType.name, value: value, context: context)
    );

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    isWideScreen = UtilViewport.getScreenWidth(context) >= 870;
  }

  void initializeWidgets() {
    if (!widgetsInitialized) {
      continueButton ??= TesArteTextIconButton(
        text: AppLocalizations.of(context)!.pushOn,
        icon: Icons.login,
        onPressed: () => continueAction(),
      );

      createUserForm ??= Form(
        key: _createUserFormKey,
        child: Column(
          spacing: 25,
          children: [
            usernameFormField!,
            continueButton!
          ],
        ),
      );

      welcomingCard = TesArteCard(
        spacing: 15,
        widgets: [
          if (!existsLastLoggedUser) ...[
            Text(AppLocalizations.of(context)!.isThisYourFirstTimeHere, textAlign: TextAlign.center,
                style: TextTheme.of(context).titleSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
            Text(AppLocalizations.of(context)!.enterNameToIdentifyYourself, textAlign: TextAlign.center,
                style: TextTheme.of(context).labelMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary.withAlpha(160))),
            createUserForm!
          ]
          else ...[
            Text("Ola de novo, ${loggedUser!.userName}!",
            style: TextTheme.of(context).titleSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary)), // TODO: lang
            SizedBox(height: 120, width: 120, child: Placeholder(color: Colors.white.withAlpha(150))),
            continueButton!
          ]
        ],
      );
    }
    widgetsInitialized = true;
  }

  void continueAction() async {
    if (!existsLastLoggedUser) {
      final FormState form = _createUserFormKey.currentState!;

      if (form.validate()) {
        User user = User(
          userName: usernameController.text,
        );
        await user.createAccount();

        if (mounted) {
          if (user.errorDB) {
            if (user.errorDBType!.contains("UNIQUE constraint failed")) {
              TesArteToast.showErrorToast(context, message: AppLocalizations.of(context)!.usernameAlreadyInUse);
            } else {
              TesArteToast.showErrorToast(context, message: AppLocalizations.of(context)!.errorOnCreatingAccount);
            }
          } else {
            TesArteToast.showSuccessToast(context, message: AppLocalizations.of(context)!.accountSuccessfullyCreated);
            TesArteSession.instance.startSession(user);
          }
        }
      }
    }
    if (mounted) context.go(HomeView.route);
  }

  // TODO:
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  RichText _getTitleView() {
    return RichText(
      textAlign: isWideScreen ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        text: "tesArte",
        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary),
        children: [
          TextSpan(
            text: "\n${AppLocalizations.of(context)!.yourCulturalLibrary}",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary.withAlpha(150))
          )
        ]
      )
    );
  }

  Future<void> getLastLoggedUser() async {
    if (!userInitialized) {
      loggedUser = User();
      await loggedUser!.getLastLoggedUser();
      existsLastLoggedUser = loggedUser!.userName.isNotEmptyAndNotNull;

      setState(() {
        userInitialized = true;
        widgetsInitialized = false;
      });
    }
  }

  Container _getTesArteLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: Image.asset(
        "lib/assets/images/tesArte_logo.png",
      ),
    );
  }

  @override
  BasicLayout build(BuildContext context) {
    getLastLoggedUser();
    initializeWidgets();

    return BasicLayout(
      showSideBar: false,
      body: isWideScreen ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [_getTesArteLogo(), _getTitleView()],
          ),
          TesArteDivider(direction: TesArteDividerDirection.vertical),
          if (loggedUser == null) TesArteLoader()
          else welcomingCard!
        ],
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getTesArteLogo(),
          _getTitleView(),
          if (loggedUser == null) TesArteLoader()
          else welcomingCard!
        ],
      )
    );
  }
}