import 'package:flutter/material.dart';

import '../../widgets/custom_bottom_navigation_bar.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(selectedTab: 1,),
      body: Center(
        child: Text("Coming soon!"),
      ),
    );
  }
}
