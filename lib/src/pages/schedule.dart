import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 获取今天是星期几，设置默认选中
    DateTime now = DateTime.now();
    int today = now.weekday; // 周一是1，周日是7
    _tabController =
        TabController(length: 7, vsync: this, initialIndex: today - 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('日程安排'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Align(
            alignment: Alignment.centerLeft, // 强制 TabBar 从左边对齐
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorPadding: EdgeInsets.zero, // 去除 indicator 左右空白
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
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('周一的日程')),
          Center(child: Text('周二的日程')),
          Center(child: Text('周三的日程')),
          Center(child: Text('周四的日程')),
          Center(child: Text('周五的日程')),
          Center(child: Text('周六的日程')),
          Center(child: Text('周日的日程')),
        ],
      ),
    );
  }
}
