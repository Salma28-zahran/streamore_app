import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:streamore_app/my_provider.dart';
import 'package:streamore_app/on_boarding_screen.dart';
import 'package:streamore_app/screens/auth/sign_in.dart';
import 'package:streamore_app/screens/auth/sign_up.dart';
import 'package:streamore_app/screens/auth/verify_email1.dart';
import 'package:streamore_app/screens/auth/verify_email2.dart';
import 'package:streamore_app/screens/auth/verify_email3.dart';
import 'package:streamore_app/screens/stream/choose_plan_screen.dart';
import 'package:streamore_app/screens/stream/drawer/contact_us_screen.dart';
import 'package:streamore_app/screens/stream/drawer/destination.dart';
import 'package:streamore_app/screens/stream/drawer/library.dart';
import 'package:streamore_app/screens/stream/drawer/members.dart';
import 'package:streamore_app/screens/stream/drawer/referrals.dart';
import 'package:streamore_app/screens/stream/drawer/settings/profile/change_password.dart';
import 'package:streamore_app/screens/stream/drawer/settings/profile/forget_pass1.dart';
import 'package:streamore_app/screens/stream/drawer/settings/profile/forget_pass2.dart';
import 'package:streamore_app/screens/stream/drawer/settings/profile/forget_pass3.dart';
import 'package:streamore_app/screens/stream/drawer/settings/profile/profile.dart';
import 'package:streamore_app/screens/stream/drawer/settings/settings.dart';
import 'package:streamore_app/screens/stream/icons/full_image_screen.dart';
import 'package:streamore_app/screens/stream/icons/settings/audio.dart';
import 'package:streamore_app/screens/stream/icons/settings/back.dart';
import 'package:streamore_app/screens/stream/icons/settings/camera.dart';
import 'package:streamore_app/screens/stream/icons/settings/general.dart';
import 'package:streamore_app/screens/stream/icons/settings/lay.dart';
import 'package:streamore_app/screens/stream/icons/settings/settings_icon.dart';
import 'package:streamore_app/screens/tabs/banners_contant.dart';
import 'package:streamore_app/theme/dark_theme.dart';
import 'package:streamore_app/theme/light_theme.dart';
import 'package:streamore_app/screens/stream/stream_screen.dart';
import 'package:streamore_app/theme/theme.dart';
import 'package:provider/provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale("ar")],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: ChangeNotifierProvider(
        create: (context) => MyProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context);

    final BaseTheme lightTheme = LightTheme();
    final BaseTheme darkTheme = DarkTheme();

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: lightTheme.themeData,
      darkTheme: darkTheme.themeData,
      themeMode: provider.themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: OnBoardingScreen.routeName,

      routes: {
        OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
        SignIn.routeName:        (context) => const SignIn(),
        SignUp.routeName:        (context) => const SignUp(),
        VerifyEmail1.routeName:  (context) => const VerifyEmail1(),
        VerifyEmail2.routeName:  (context) => const VerifyEmail2(),
        VerifyEmail3.routeName:  (context) => const VerifyEmail3(),
        StreamScreen.routeName:  (context) => const StreamScreen(),
        Library.routeName:       (context) => const Library(),
        Members.routeName:       (context) => const Members(),
        Destination.routeName:   (context) => const Destination(),
        Referrals.routeName:     (context) => const Referrals(),
        Settings.routeName:      (context) => const Settings(),
        SettingsIcon.routeName:  (context) => const SettingsIcon(),
        General.routeName:       (context) => const General(),
        Camera.routeName:        (context) => const Camera(),
        Audio.routeName:         (context) => const Audio(),
        Back.routeName:          (context) => const Back(),
        LayoutScreen.routeName:  (context) => const LayoutScreen(),
        Profile.routeName:       (context) => const Profile(),
        ContactUsScreen.routeName: (context) => const ContactUsScreen(),
        ChoosePlanScreen.routeName: (context) => const ChoosePlanScreen(),
        ChangePassword.routeName:(context)=> const ChangePassword(),
        ForgetPass1.routeName:(context)=>const ForgetPass1(),
        ForgetPass2.routeName:(context)=>ForgetPass2(),
        ForgetPass3.routeName:(context)=>ForgetPass3(),
        FullImageScreen.routeName:(context)=>FullImageScreen(),



        BannersContant.routeName : (context) => const BannersContant(),
      },
    );
  }
}