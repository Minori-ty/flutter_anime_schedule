import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;
  final TabController? controller;
  const TabAppBar({required this.tabs, this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Get.isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: Colors.transparent,
            ),
      child: Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top, right: 4),
        height: 56 + MediaQuery.of(context).padding.top,
        child: Row(
          children: [
            Expanded(
              child: TabBar(
                isScrollable: true,
                controller: controller,
                labelColor: Theme.of(context).colorScheme.primary,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor:
                    Get.isDarkMode ? Colors.white70 : Colors.black87,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 12),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabs: tabs,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(56 + MediaQuery.of(Get.context!).padding.top);
}
