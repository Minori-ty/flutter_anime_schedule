import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/utils/index.dart';

void main() {
  test('周在updateWeek之后', () {
    // 创建一个 AnimeModel 实例
    AnimeModel anime = AnimeModel(
      name: 're0',
      updateWeek: '周三',
      updateTime: '10:30',
      currentEpisode: 2,
      totalEpisode: 8,
      cover: 'http://example.com/cover.jpg',
    );
    anime.createdAt = DateTime(2025, 2, 14, 10, 0); // 设置创建日期

    // 调用 getFirstEpisodeTime 函数
    int updatedEpisodes = getCurrentWeekUpdatedEpisodes(anime);

    // 断言结果
    expect(updatedEpisodes, 2);
  });

  test('周在updateWeek之前', () {
    // 创建一个 AnimeModel 实例
    AnimeModel anime = AnimeModel(
      name: '独自升级',
      updateWeek: '周六',
      updateTime: '23:45',
      currentEpisode: 6,
      totalEpisode: 13,
      cover: 'http://example.com/cover.jpg',
    );
    anime.createdAt = DateTime(2025, 2, 14, 10, 0); // 设置创建日期

    // 调用 getFirstEpisodeTime 函数
    int updatedEpisodes = getCurrentWeekUpdatedEpisodes(anime);

    // 断言结果
    expect(updatedEpisodes, 7);
  });
}
