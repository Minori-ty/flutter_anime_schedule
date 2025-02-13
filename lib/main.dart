import 'package:flutter/material.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:get/get.dart';
import 'package:flutter_anime_schedule/src/pages/schedule.dart';
import 'package:flutter_anime_schedule/src/pages/my_anime.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // 确保 Flutter 的绑定被初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AnimeModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatelessWidget {
  final MainController mainController = Get.put(MainController());

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: mainController.selectedIndex.value,
          children: [
            SchedulePage(),
            MyAnimePage(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: mainController.selectedIndex.value,
          onTap: (index) {
            mainController.changeTabIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.update),
              label: '更新表',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: '我的追番',
            ),
          ],
        );
      }),
    );
  }
}

class MainController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
