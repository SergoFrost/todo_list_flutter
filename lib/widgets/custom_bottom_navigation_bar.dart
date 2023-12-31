import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedTab;

  const CustomBottomNavigationBar({super.key, required this.selectedTab});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void onTapHandler(int index) {
    if (widget.selectedTab != index) {
      if (index == 0) {
        Get.toNamed('/');
      } else if (index == 1) {
        Get.toNamed('/stats');
      } else if (index == 2) {
        Get.toNamed('/calendar');
      } else {
        Get.toNamed('/settings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      enableFeedback: true,
      selectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedTab,
      onTap: (int index) {
        onTapHandler(index);
      },
      items: [
        BottomNavigationBarItem(
          label: '',
          activeIcon: SvgPicture.asset(
            "assets/bottom_navigation_icons/home.svg",
            height: 23,
            color: Colors.black,
          ),
          icon: SvgPicture.asset(
            "assets/bottom_navigation_icons/home.svg",
            height: 23,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          activeIcon: SvgPicture.asset(
            "assets/bottom_navigation_icons/stats.svg",
            height: 23,
            color: Colors.black,
          ),
          icon: SvgPicture.asset(
            "assets/bottom_navigation_icons/stats.svg",
            height: 23,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          activeIcon: SvgPicture.asset(
            "assets/bottom_navigation_icons/calendar.svg",
            height: 23,
            color: Colors.black,
          ),
          icon: SvgPicture.asset(
            "assets/bottom_navigation_icons/calendar.svg",
            height: 20,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          activeIcon: SvgPicture.asset(
            "assets/bottom_navigation_icons/settings.svg",
            height: 23,
            color: Colors.black,
          ),
          icon: SvgPicture.asset(
            "assets/bottom_navigation_icons/settings.svg",
            height: 23,
          ),
        ),
      ],
    );
  }
}
