import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/account_module/account_screen.dart';
import 'package:projekx_app/modules/project_module/project_list_view.dart';
import 'package:projekx_app/modules/task_module/my_tasks.dart';

class MyBottomNavBar extends StatefulWidget {
  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int selectedIndex = 0;

  final List<TabItem> items = [
    TabItem(icon: LucideIcons.layoutGrid, title: 'Projects'),
    // TabItem(icon: LucideIcons.checkSquare, title: 'Tasks'),
    TabItem(icon: LucideIcons.user, title: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: selectedIndex,
        children: [ProjectListView(), 
        // MyTaskListView(),
         AccountView()],
      ),
      bottomNavigationBar: BottomBarInspiredOutside(
        items: items,
        backgroundColor: Colors.white,
        color: AppColors.primary.withOpacity(0.6),
        colorSelected: Colors.white,
        indexSelected: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        top: -28,
        animated: true,
        itemStyle: ItemStyle.circle,
        chipStyle: ChipStyle(
          background: AppColors.primary,
          color: Colors.white,
          notchSmoothness: NotchSmoothness.smoothEdge,
        ),
      ),
    );
  }
}
