// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:split/core/widgets/base_stateless_widget.dart';
import 'package:split/feature/navigator/navigator_bloc/navigator_bloc.dart';
import 'package:split/feature/navigator/navigator_bloc/navigator_event.dart';
import 'package:split/feature/navigator/navigator_bloc/navigator_state.dart';
import 'package:split/feature/navigator/widgets/custom_navigation_bar_icon.dart';
import 'package:split/utils/locale/app_localization_keys.dart';

class CustomBottomNavigationBar extends BaseStatelessWidget {
  CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    int currentScreen = 0;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 55.h,
        child: BlocBuilder<NavigatorBloc, NavigatorBlocSates>(
          builder: (context, state) {
            if (state is NavigateToGroupScreenState) {
              currentScreen = 0;
            } else if (state is NavigateToFriendsScreenState) {
              currentScreen = 1;
            } else if (state is NavigateToActivityScreenState) {
              currentScreen = 2;
            } else if (state is NavigateToProfileScreenState) {
              currentScreen = 3;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                /// Group Icon
                _navigationIconWidget(translate(LocalizationKeys.groups)!, 0,
                    currentScreen, context),

                /// friends Icon
                _navigationIconWidget(translate(LocalizationKeys.friends)!, 1,
                    currentScreen, context),

                ///  activity
                _navigationIconWidget(translate(LocalizationKeys.activity)!, 2,
                    currentScreen, context),

                // account
                _navigationIconWidget(translate(LocalizationKeys.account)!, 3,
                    currentScreen, context)
              ],
            );
          },
        ),
      ),
    );
  }

  /// ////////////////////////////////////////////////////////
  /// ///////////////// Widget methods ///////////////////////
  /// ////////////////////////////////////////////////////////
  Widget _navigationIconWidget(
      String name, int iconIndex, int currentScreen, BuildContext context) {
    return InkWell(
      onTap: () {
        if (iconIndex == 0) {
          _makeGroupsTheScreen(context);
        } else if (iconIndex == 1) {
          _makeFriendsTheCurrentScreen(context);
        } else if (iconIndex == 2) {
          _makeActivityTheCurrentScreen(context);
        } else if (iconIndex == 3) {
          _makeProfileTheCurrentScreen(context);
        }
      },
      child: CustomNavigationBarIcon(
          name: name, iconIndex: iconIndex, selectedIconIndex: currentScreen),
    );
  }

  /// ////////////////////////////////////////////////////////
  /// ///////////////// Helper methods ///////////////////////
  /// ////////////////////////////////////////////////////////

  NavigatorBloc currentBloc(BuildContext context) =>
      context.read<NavigatorBloc>();

  /// this is a list of fired events
  _makeGroupsTheScreen(BuildContext context) {
    currentBloc(context).add(MakeGroupsTheCurrentScreenEvent());
  }

  _makeFriendsTheCurrentScreen(BuildContext context) =>
      currentBloc(context).add(MakeFriendsTheCurrentScreenEvent());

  _makeActivityTheCurrentScreen(BuildContext context) =>
      currentBloc(context).add(MakeActivityTheCurrentScreenEvent());

  _makeProfileTheCurrentScreen(BuildContext context) =>
      currentBloc(context).add(MakeProfileTheCurrentScreenEvent());
}
