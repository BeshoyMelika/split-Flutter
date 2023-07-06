import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:split/apis/_base/dio_api_manager.dart';
import 'package:split/feature/auth/auth_bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:split/feature/auth/auth_bloc/otp_verification_bloc/otp_verification_bloc.dart';
import 'package:split/feature/auth/auth_bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:split/feature/auth/auth_bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:split/feature/auth/auth_bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:split/feature/auth/screens/forget_password_screen.dart';
import 'package:split/feature/auth/screens/otp_screen.dart';
import 'package:split/feature/auth/screens/reset_password_screen.dart';
import 'package:split/feature/auth/screens/sign_in_screen.dart';
import 'package:split/feature/auth/screens/sign_up_screen.dart';
import 'package:split/feature/auth/screens/success_message_screen.dart';
import 'package:split/feature/splash/screen/splash_screen.dart';

import 'package:split/preferences/preferences_manager.dart';
import 'package:split/res/app_colors.dart';
import 'package:split/utils/locale/app_localization.dart';
import 'package:split/utils/locale/app_localization_keys.dart';
import 'package:split/utils/locale/locale_cubit.dart';
import 'package:split/utils/locale/locale_repository.dart';

import 'package:split/utils/status_bar/statusbar_controller.dart';
import 'package:split/utils/theme/app_theme.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  PreferencesManager preferencesManager = GetIt.I<PreferencesManager>();

  @override
  Widget build(BuildContext context) {
    _changeStatusBarColor();
    DioApiManager dioApiManager = GetIt.I<DioApiManager>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(
              LocaleRepository(dioApiManager, (GetIt.I<PreferencesManager>()))),
        ),
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => OtpVerificationBloc()),
        BlocProvider(create: (context) => ForgetPasswordBloc()),
        BlocProvider(create: (context) => ResetPasswordBloc()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, state) {
          return KeyboardDismisser(
            gestures: Platform.isAndroid ? [] : [GestureType.onTap],
            child: ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (context, child) => MaterialApp(
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(context)
                        ?.translate(LocalizationKeys.appName) ??
                    "Split",
                debugShowCheckedModeBanner: false,
                theme: AppTheme(state).themeDataLight,
                darkTheme: AppTheme(state).themeDataDark,
                themeMode: ThemeMode.light,

                /// the list of our supported locals for our app
                /// currently we support only 2 English and Arabic ...
                supportedLocales: AppLocalizations.supportedLocales,

                /// these delegates make sure that the localization data
                /// for the proper
                /// language is loaded ...
                localizationsDelegates: const [
                  /// A class which loads the translations from JSON files
                  AppLocalizations.delegate,

                  /// Built-in localization of basic text
                  ///  for Material widgets in Material
                  GlobalMaterialLocalizations.delegate,

                  /// Built-in localization for text direction LTR/RTL
                  GlobalWidgetsLocalizations.delegate,

                  /// Built-in localization for text direction LTR/RTL in Cupertino
                  GlobalCupertinoLocalizations.delegate,

                  DefaultCupertinoLocalizations.delegate,
                ],
                locale: state,

                routes: {
                  SignInScreen.routeName: (context) => const SignInScreen(),
                  SignUpScreen.routeName: (context) => const SignUpScreen(),
                  ForgetPasswordScreen.routeName: (context) =>
                      const ForgetPasswordScreen(),
                  ResetPasswordScreen.routeName: (context) =>
                      const ResetPasswordScreen(),
                  SuccessMessageScreen.routeName: (context) =>
                      const SuccessMessageScreen(),
                  OtpScreen.routName: (context) => const OtpScreen(),
                },
                home: const SplashScreen(),
              ),
            ),
          );
        },
      ),
    );
  }

  void _changeStatusBarColor() {
    setStatusBarColor(AppColors.colorPrimary);
  }
}
