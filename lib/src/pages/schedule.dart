import 'package:flutter/material.dart';
import 'package:flutter_anime_schedule/src/conponents/tab_appbar.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    int currentDayOfWeek = (DateTime.now().weekday - 1) % 7;

    return DefaultTabController(
      length: 7,
      initialIndex: currentDayOfWeek,
      child: Scaffold(
        appBar: TabAppBar(
          tabs: [
            Tab(text: '周一'),
            Tab(text: '周二'),
            Tab(text: '周三'),
            Tab(text: '周四'),
            Tab(text: '周五'),
            Tab(text: '周六'),
            Tab(text: '周日'),
          ],
        ),
        body: TabBarView(
          children: [
            Center(child: Text('周一的内容')),
            Center(child: Text('周二的内容')),
            Center(child: Text('周三的内容')),
            Center(child: Text('周四的内容')),
            Center(child: Text('周五的内容')),
            Center(child: Text('周六的内容')),
            Center(child: Text('周日的内容')),
          ],
        ),
      ),
    );
  }
}
