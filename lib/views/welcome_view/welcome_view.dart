import 'package:tesArte/common/components/tesarte_card.dart';
import 'package:tesArte/common/components/tesarte_divider.dart';
import 'package:tesArte/common/components/tesarte_loader/tesArte_loader.dart';
import 'package:tesArte/common/components/tesarte_toast.dart';
import 'package:tesArte/common/components/form/tesarte_text_form_field.dart';
import 'package:tesArte/common/components/tesarte_text_icon_button.dart';
import 'package:tesArte/common/utils/tesarte_validator.dart';
import 'package:tesArte/common/utils/util_viewport.dart';
import 'package:tesArte/common/layouts/basic_layout.dart';
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
  bool? existsUserInDB;

  late TesArteCard welcomingCard;

  late Form createUserForm;

  late TextEditingController usernameController;

  late TesArteTextFormField usernameFormField;
  late TesArteTextIconButton continueButton;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();

    usernameFormField = TesArteTextFormField(
        controller: usernameController,
        hintText: "tesArteTeo",
        maxWidth: 350,
        bordered: false,
        validator: (value) => TesArteValidator.doValidation(type: TesArteValidatorType.name, value: value)
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    isWideScreen = UtilViewport.getScreenWidth(context) >= 870;

    continueButton = TesArteTextIconButton(
      text: "Continuar", // TODO: lang
      onPressed: () => validateFormAndContinue(),
    );

    createUserForm = Form(
      key: _createUserFormKey,
      child: Column(
        spacing: 25,
        children: [
          usernameFormField,
          continueButton
        ],
      ),
    );

    welcomingCard = TesArteCard(
      spacing: 5,
      widgets: [
        Text("Benvid@!", textAlign: TextAlign.center,
            style: TextTheme.of(context).titleSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
        Text("Escribe un nome co que identificarte:", textAlign: TextAlign.center,
            style: TextTheme.of(context).labelMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
        createUserForm
      ],
    );
  }

  void validateFormAndContinue() async {
    final FormState form = _createUserFormKey.currentState!;

    if (form.validate()) {
      User user = User(
        userName: usernameController.text,
      );

      await user.createAccount();

      if (mounted) {
        if (user.errorDB) {
          if (user.errorDBType!.contains("UNIQUE constraint failed")) {
            TesArteToast.showErrorToast(context, message: "El nombre de usuario ya está en uso."); // TODO: lang
          } else {
            TesArteToast.showErrorToast(context, message: "Ha ocurrido un error al intentar crear la cuenta."); // TODO: lang
          }
        } else {
          TesArteToast.showSuccessToast(context, message: "Cuenta creada correctamente."); // TODO: lang
          context.go(HomeView.route);
        }
      }
    }
  }

  // TODO:
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  RichText _getTitle() {
    return RichText(
      textAlign: isWideScreen ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        text: "tesArte", // TODO: lang
        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary),
        children: [
          TextSpan(
            text: "\na túa biblioteca cultural", // TODO: lang
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary.withAlpha(150))
          )
        ]
      )
    );
  }

  Future<bool> checkExistsUserIntesArteDB() async {
    existsUserInDB ??= await User.existsUsersInDB();

    return existsUserInDB ?? false;
  }

  Container _gettesArteLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: Image.asset(
        "lib/assets/images/tesArte_logo.png",
      ),
    );
  }

  FutureBuilder<bool> getContentCard() {
    return FutureBuilder<bool>(
      future: existsUserInDB == null ? checkExistsUserIntesArteDB() : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TesArteLoader();
        } else if (snapshot.hasData && snapshot.data!) {
          WidgetsBinding.instance.addPostFrameCallback((_) => context.go(HomeView.route));
          return TesArteLoader();
        } else {
          return welcomingCard;
        }
      },
    );
  }

  @override
  BasicLayout build(BuildContext context) {
    return BasicLayout(
      body: isWideScreen ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [_gettesArteLogo(), _getTitle()],
          ),
          TesArteDivider(direction: TesArteDividerDirection.vertical),
          getContentCard(),
        ],
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _gettesArteLogo(),
          _getTitle(),
          getContentCard(),
        ],
      )
    );
  }
}