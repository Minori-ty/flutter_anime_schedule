import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';

DateTime now = DateTime.now();

/// 还没更新，2025-02-06 14:30
AnimeModel updateTimeBeforeWeekday = AnimeModel(
  name: 'Test Anime',
  updateWeekday: convertIntToWeekday(now.add(Duration(days: 1)).weekday), // 周四
  updateTime: '14:30',
  currentEpisode: 2,
  totalEpisode: 3,
  cover: 'http://example.com/cover.jpg',
);

/// 已经更新，2025-02-11 14:30
AnimeModel updateTimeAfterWeekday = AnimeModel(
  name: 'Test Anime',
  updateWeekday:
      convertIntToWeekday(now.subtract(Duration(days: 1)).weekday), // 周二
  updateTime: '14:30',
  currentEpisode: 2,
  totalEpisode: 2,
  cover: 'http://example.com/cover.jpg',
);

/// 还没更新，2025-02-05 20:00
AnimeModel updateTimeBeforeUpdateTime = AnimeModel(
  name: 'Test Anime',
  updateWeekday: convertIntToWeekday(now.weekday),
  updateTime: '20:00',
  currentEpisode: 2,
  totalEpisode: 3,
  cover: 'http://example.com/cover.jpg',
);

/// 已经更新，2025-02-12 04:00
AnimeModel updateTimeAfterUpdateTime = AnimeModel(
  name: 'Test Anime',
  updateWeekday: convertIntToWeekday(now.weekday),
  updateTime: '04:00',
  currentEpisode: 2,
  totalEpisode: 3,
  cover: 'http://example.com/cover.jpg',
);

/// 还没更新，2025-02-20 04:00
AnimeModel updateTimeAfterNow = AnimeModel(
  name: 'Test Anime',
  updateWeekday: convertIntToWeekday(now.add(Duration(days: 1)).weekday),
  updateTime: '04:00',
  currentEpisode: 0,
  totalEpisode: 3,
  cover: 'http://example.com/cover.jpg',
);
