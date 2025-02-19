import 'package:hive/hive.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';

class AnimeService {
  static const String boxName = 'animeBox';

  Future<Map<String, dynamic>> addAnime(AnimeModel anime) async {
    final box = await Hive.openBox<AnimeModel>(boxName);
    await box.put(anime.id, anime);
    return {'code': 200, 'msg': "添加成功", 'data': anime};
  }

  Future<Map<String, dynamic>> deleteAnime(String id) async {
    final box = await Hive.openBox<AnimeModel>(boxName);
    await box.delete(id);
    return {'code': 200, 'msg': "删除成功"};
  }

  Future<Map<String, dynamic>> updateAnime(AnimeModel anime) async {
    final box = await Hive.openBox<AnimeModel>(boxName);
    await box.put(anime.id, anime);
    return {'code': 200, 'msg': "修改成功", 'data': anime};
  }

  Future<Map<String, dynamic>> getAnime(String id) async {
    final box = await Hive.openBox<AnimeModel>(boxName);
    final anime = box.get(id);
    if (anime != null) {
      return {'code': 200, 'msg': "查找成功", 'data': anime};
    } else {
      return {'code': 404, 'msg': "未找到该动漫"};
    }
  }

  Future<Map<String, dynamic>> getAnimes() async {
    final box = await Hive.openBox<AnimeModel>(boxName);
    final animes = box.values.toList();
    return {'code': 200, 'msg': "查找成功", 'data': animes};
  }
}
