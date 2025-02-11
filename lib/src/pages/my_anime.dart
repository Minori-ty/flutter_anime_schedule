import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_anime_schedule/src/pages/add_anime.dart';

class MyAnimePage extends StatelessWidget {
  const MyAnimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的追番'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() => AddAnimePage());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('我的追番页面'),
      ),
    );
  }
}
