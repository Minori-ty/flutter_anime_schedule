import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/utils/index.dart';

void main() {
  test('周在updateWeek之后', () {
    // 创建一个 AnimeModel 实例
    AnimeModel anime = AnimeModel(
      name: 'Test Anime',
      updateWeek: '周三',
      updateTime: '14:30',
      currentEpisode: 3,
      totalEpisode: 12,
      cover: 'http://example.com/cover.jpg',
    );
    anime.createdAt = DateTime(2025, 2, 13, 10, 0); // 设置创建日期

    // 调用 getFirstEpisodeTime 函数
    String firstEpisodeTime = getFirstEpisodeTime(anime);

    // 断言结果
    expect(firstEpisodeTime, '2025-01-29 14:30');
  });

  test('周在updateWeek之前', () {
    // 创建一个 AnimeModel 实例
    AnimeModel anime = AnimeModel(
      name: 'Test Anime',
      updateWeek: '周五',
      updateTime: '20:00',
      currentEpisode: 3,
      totalEpisode: 12,
      cover: 'http://example.com/cover.jpg',
    );
    anime.createdAt = DateTime(2025, 2, 13, 10, 0); // 设置创建日期

    // 调用 getFirstEpisodeTime 函数
    String firstEpisodeTime = getFirstEpisodeTime(anime);

    // 断言结果
    expect(firstEpisodeTime, '2025-01-24 20:00');
  });

  test('同周updateTime之前', () {
    // 创建一个 AnimeModel 实例
    AnimeModel anime = AnimeModel(
      name: 'Test Anime',
      updateWeek: '周四',
      updateTime: '10:00',
      currentEpisode: 2,
      totalEpisode: 12,
      cover: 'http://example.com/cover.jpg',
    );
    anime.createdAt = DateTime(2025, 2, 13, 9, 0); // 设置创建日期

    // 调用 getFirstEpisodeTime 函数
    String firstEpisodeTime = getFirstEpisodeTime(anime);

    // 断言结果
    expect(firstEpisodeTime, '2025-01-30 10:00');
  });

  test('同周updateTime之后', () {
    // 创建一个 AnimeModel 实例
    AnimeModel anime = AnimeModel(
      name: 'Test Anime',
      updateWeek: '周四',
      updateTime: '10:00',
      currentEpisode: 2,
      totalEpisode: 12,
      cover: 'http://example.com/cover.jpg',
    );
    anime.createdAt = DateTime(2025, 2, 13, 11, 0); // 设置创建日期

    // 调用 getFirstEpisodeTime 函数
    String firstEpisodeTime = getFirstEpisodeTime(anime);

    // 断言结果
    expect(firstEpisodeTime, '2025-02-06 10:00');
  });
}
