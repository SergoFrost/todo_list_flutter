import 'package:flutter/material.dart';

import '../../widgets/custom_bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(selectedTab: 3,),
      body: Center(
        child: Text("Coming soon!"),
      ),
    );
  }
}
