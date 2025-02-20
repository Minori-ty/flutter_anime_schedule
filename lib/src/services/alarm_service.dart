import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_anime_schedule/src/services/notification_service.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AlarmService {
  Future<void> init() async {
    final bool initialized = await AndroidAlarmManager.initialize();
    if (initialized) {
      // 设置一个每隔 10 分钟触发的闹钟
      await AndroidAlarmManager.periodic(
        const Duration(seconds: 10),
        0,
        notification,
        exact: true,
        wakeup: true,
      );
    } else {
      NotificationService().showNotification(
        '定时任务初始化失败',
        '定时任务初始化失败',
      );
    }
  }

  @pragma('vm:entry-point')
  static void notification() async {
    AnimeService animeService = AnimeService();
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AnimeModelAdapter());
    }
    Map<String, dynamic> response = await animeService.getAnimes();
    if (response['code'] == 200) {
      List<AnimeModel> animes = List<AnimeModel>.from(response['data']);
      for (var anime in animes) {
        notificationAnime(anime, animeService);
        updateBeforeWeekdayNotification(anime, animeService);
      }
    } else {
      return Future.error('Failed to load animes');
    }
  }

  /// 是否需要通知更新
  static bool needNotification(AnimeModel anime) {
    DateTime now = DateTime.now();
    String currentTime = DateFormat('HH:mm').format(now);
    bool isTheSameWeekday =
        convertWeekdayToInt(anime.updateWeekday) == DateTime.now().weekday;
    // 现在的时间是否大于updateTime
    bool isAfterUpdateTime = currentTime.compareTo(anime.updateTime) >= 0;
    bool isInUpdateRange = isShowInThisWeek(anime);
    if (isInUpdateRange &&
        isTheSameWeekday &&
        isAfterUpdateTime &&
        !anime.isNotification) {
      return true;
    }
    return false;
  }

  static void notificationAnime(AnimeModel anime, AnimeService animeService) {
    if (needNotification(anime)) {
      NotificationService().showNotification(
        '${anime.name}第${getShouldUpdateEpisodes(anime)}集更新',
        '${anime.name}第${getShouldUpdateEpisodes(anime)}集更新',
      );
      animeService.updateAnimeNotificationStatus(anime, true);
    }
  }

  static void updateBeforeWeekdayNotification(
      AnimeModel anime, AnimeService animeService) {
    int currentWeekday = DateTime.now().weekday;
    if (currentWeekday == 1) {
      currentWeekday = 8;
    }

    int beforeWeekday = currentWeekday - 1;
    bool isInUpdateRange = isShowInThisWeek(anime);
    bool isBeforeWeekday =
        convertWeekdayToInt(anime.updateWeekday) == beforeWeekday;
    if (isInUpdateRange && isBeforeWeekday && anime.isNotification) {
      animeService.updateAnimeNotificationStatus(anime, false);
    }
  }
}
