import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAnimePage extends StatelessWidget {
  final TextEditingController animeController = TextEditingController();

  AddAnimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加新追番'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: animeController,
              decoration: InputDecoration(
                labelText: '追番名称',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 在这里处理创建新追番的逻辑
                String newAnime = animeController.text;
                if (newAnime.isNotEmpty) {
                  // 例如，将新追番添加到列表中或数据库中
                  Get.back();
                }
              },
              child: Text('创建'),
            ),
          ],
        ),
      ),
    );
  }
}
