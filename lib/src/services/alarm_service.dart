import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_anime_schedule/src/services/notification_service.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';
import 'package:flutter_anime_schedule/src/utils/index.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
        if (convertWeekdayToInt(anime.updateWeek) == DateTime.now().weekday &&
            anime.updateTime ==
                "${DateTime.now().hour}:${DateTime.now().minute}") {
          NotificationService().showNotification(
            '${anime.name}第${getCurrentWeekUpdatedEpisodes(anime)}集更新',
            '${anime.name}第${getCurrentWeekUpdatedEpisodes(anime)}集更新',
          );
        }
      }
    } else {
      return Future.error('Failed to load animes');
    }
  }
}
