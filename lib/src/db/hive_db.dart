// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_anime_schedule/src/models/anime_model.dart';

// class HiveDB {
//   static late Box<AnimeModel> _animeBox;

//   static Future<void> init() async {
//     final directory = await getApplicationDocumentsDirectory();
//     Hive.init(directory.path);
//     Hive.registerAdapter(AnimeModelAdapter());
//     _animeBox = await Hive.openBox<AnimeModel>('animeBox');
//   }

// // 添加动漫
//   static Future<Map<String, dynamic>> addAnime(AnimeModel anime) async {
//     try {
//       if (anime.id == -1) {
//         anime.id = await _animeBox.add(anime);
//       }

//       // 返回成功信息
//       return {'code': 200, 'msg': "添加成功", 'data': anime};
//     } catch (e) {
//       print('Error adding anime to Hive: $e');
//       return {'code': 500, 'msg': "添加失败", 'data': null};
//     }
//   }

//   // 删除动漫
//   static Future<Map<String, dynamic>> deleteAnime(int id) async {
//     print('删除动漫: $id');
//     try {
//       if (id != -1) {
//         await _animeBox.delete(id);
//         return {'code': 200, 'msg': "删除成功"};
//       } else {
//         return {'code': 400, 'msg': "无效的 id"};
//       }
//     } catch (e) {
//       return {'code': 500, 'msg': "删除失败", 'data': null};
//     }
//   }

//   // 更新动漫
//   static Future<Map<String, dynamic>> updateAnime(AnimeModel anime) async {
//     try {
//       await _animeBox.put(anime.id, anime); // Save or update using 'put'
//       return {'code': 200, 'msg': "修改成功", 'data': anime};
//     } catch (e) {
//       return {'code': 500, 'msg': "修改失败", 'data': null};
//     }
//   }

//   // 获取动漫
//   static Map<String, dynamic> getAnime(int id) {
//     AnimeModel? anime = _animeBox.get(id);
//     if (anime != null) {
//       return {'code': 200, 'msg': "查找成功", 'data': anime};
//     }
//     return {'code': 404, 'msg': "未找到数据", 'data': null};
//   }

//   // 获取所有动漫
//   static Future<Map<String, dynamic>> getAnimes() async {
//     List<AnimeModel> animeList = _animeBox.values.toList();
//     return {'code': 200, 'msg': "查找成功", 'data': animeList};
//   }
// }
