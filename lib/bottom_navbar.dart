import 'package:evangelism_admin/core/prospect/presentation/pages/register_prospect.dart';
import 'package:evangelism_admin/src/location/presentation/pages/location_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'shared/presentation/theme/extra_colors.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> _buildScreens() {
    return [
      const RegisterProspectPage(),
      const LocationPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: Theme.of(context).textTheme.labelLarge,
        icon: const Icon(IconlyLight.add_user),
        title: 'Register',
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: ExtraColors.darkGrey,
      ),
      PersistentBottomNavBarItem(
        textStyle: Theme.of(context).textTheme.labelLarge,
        icon: const Icon(IconlyLight.location),
        title: 'Location',
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: ExtraColors.darkGrey,
      ),
    ];
  }

  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 0,
          color: ExtraColors.grey,
        ),
        Flexible(
          child: PersistentTabView(
            navBarHeight: 65,
            padding:
                const NavBarPadding.only(left: 0, right: 0, bottom: 0, top: 0),
            context,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: ExtraColors.white,
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 700),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 700),
            ),
            navBarStyle: NavBarStyle.style9,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: false,
            decoration: const NavBarDecoration(
              border: Border(top: BorderSide(color: ExtraColors.lightGrey)),
            ),
          ),
        ),
      ],
    );
  }
}