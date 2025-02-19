import 'package:intl/intl.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';

/// 根据updateWeekday和updateTime判断本周是否更新了
bool isUpdateInThisWeek(AnimeModel anime, {DateTime? now}) {
  // // 获取当前日期和时间
  // DateTime now = DateTime.now();
  now ??= DateTime.now();

  // 获取当前的星期几 (1 = Monday, 7 = Sunday)
  int currentWeekday = now.weekday;

  if (convertWeekdayToInt(anime.updateWeekday) > currentWeekday) {
    return false;
  } else if (convertWeekdayToInt(anime.updateWeekday) < currentWeekday) {
    return true;
  } else {
    String currentTime = DateFormat('HH:mm').format(now);

    // 如果当前时间大于等于更新时间，则返回true
    if (currentTime.compareTo(anime.updateTime) >= 0) {
      return true;
    }

    return false;
  }
}

/// 将更新周转换为整数表示
int convertWeekdayToInt(String weekday) {
  switch (weekday) {
    case '周一':
      return DateTime.monday;
    case '周二':
      return DateTime.tuesday;
    case '周三':
      return DateTime.wednesday;
    case '周四':
      return DateTime.thursday;
    case '周五':
      return DateTime.friday;
    case '周六':
      return DateTime.saturday;
    case '周日':
      return DateTime.sunday;
    default:
      throw ArgumentError('Invalid weekday: $weekday'); // 抛出无效周错误
  }
}

String convertIntToWeekday(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "周一";
    case DateTime.tuesday:
      return "周二";
    case DateTime.wednesday:
      return "周三";
    case DateTime.thursday:
      return "周四";
    case DateTime.friday:
      return "周五";
    case DateTime.saturday:
      return "周六";
    case DateTime.sunday:
      return "周日";
    default:
      throw ArgumentError('Invalid weekday: $weekday'); // 抛出无效周错误
  }
}

/// 将 DateTime 转换为 YYYY-MM-DD HH:mm
String formatDateTime(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
}

/// 将 YYYY-MM-DD HH:mm 转换为 DateTime
DateTime parseDateTime(String dateTimeString) {
  List<String> parts = dateTimeString.split(' ');
  List<String> dateParts = parts[0].split('-');
  List<String> timeParts = parts[1].split(':');

  return DateTime(
    int.parse(dateParts[0]),
    int.parse(dateParts[1]),
    int.parse(dateParts[2]),
    int.parse(timeParts[0]),
    int.parse(timeParts[1]),
  );
}

/// 传入一个时间，返回该时间所在周的更新时间
DateTime getUpdateTimeThisWeek(AnimeModel anime, DateTime date) {
  int updateWeekday = convertWeekdayToInt(anime.updateWeekday);
  DateTime update = date.subtract(Duration(days: date.weekday - updateWeekday));
  return DateTime(
      update.year,
      update.month,
      update.day,
      int.parse(anime.updateTime.split(':')[0]),
      int.parse(anime.updateTime.split(':')[1]));
}

/// 根据番剧信息计算第一集的更新时间
DateTime getFirstEpisodeTime(AnimeModel anime) {
  DateTime createdAt = anime.createdAt;
  DateTime updateTime = getUpdateTimeThisWeek(anime, createdAt);
  int offsetWeeks;
  if (isUpdateInThisWeek(anime, now: createdAt)) {
    offsetWeeks = anime.currentEpisode - 1;
  } else {
    offsetWeeks = anime.currentEpisode;
  }
  return updateTime.subtract(Duration(days: offsetWeeks * 7));
}

/// 根据番剧信息计算最后一集的更新时间
DateTime getLastEpisodeTime(AnimeModel anime) {
  return getFirstEpisodeTime(anime)
      .add(Duration(days: (anime.totalEpisode - 1) * 7));
}

/// 返回本周应该更新的集数
int getShouldUpdateEpisodes(AnimeModel anime) {
  DateTime now = DateTime.now();
  DateTime updateTime = getUpdateTimeThisWeek(anime, now);
  Duration timeDifference = updateTime.difference(getFirstEpisodeTime(anime));
  int weeksPassed = (timeDifference.inDays ~/ 7) + 1;
  if (weeksPassed >= anime.totalEpisode) {
    return anime.totalEpisode;
  } else {
    return weeksPassed;
  }
}

/// 返回本周已经更新的集数
int getUpdatedEpisodes(AnimeModel anime) {
  if (isAnimeCompleted(anime)) {
    return anime.totalEpisode;
  }
  int episodes = getShouldUpdateEpisodes(anime);
  if (isUpdateInThisWeek(anime)) {
    return episodes;
  } else {
    return episodes - 1;
  }
}

/// 获取上周日23:59:59
DateTime getLastSunday235959() {
  // 获取当前时间
  DateTime now = DateTime.now();
  // 获取当前是本周的第几天（1 表示周一，7 表示周日）
  int currentWeekday = now.weekday;
  // 计算本周一的日期
  DateTime thisMonday = now.subtract(Duration(days: currentWeekday - 1));
  // 从本周一往前推一天得到上周日的日期
  DateTime lastSunday = thisMonday.subtract(Duration(days: 1));
  // 将时间设置为 23:59
  return DateTime(
      lastSunday.year, lastSunday.month, lastSunday.day, 23, 59, 59);
}

bool isShowInThisWeek(AnimeModel anime) {
  DateTime lastSunday = getLastSunday235959();
  DateTime lastUpdateTime = getLastEpisodeTime(anime);
  int espisode = getShouldUpdateEpisodes(anime);
  return lastUpdateTime.isAfter(lastSunday) && espisode >= 1;
}

/// 分组 AnimeModel，根据 updateWeekday 和 updateTime
Map<String, Map<String, List<AnimeModel>>> groupAnimeByWeekAndTime(
    List<AnimeModel> animeList) {
  Map<String, Map<String, List<AnimeModel>>> groupedAnime = {
    '周一': {},
    '周二': {},
    '周三': {},
    '周四': {},
    '周五': {},
    '周六': {},
    '周日': {},
  };

  for (AnimeModel anime in animeList) {
    // 过滤掉在本周之前完结的动漫
    if (isShowInThisWeek(anime)) {
      if (!groupedAnime[anime.updateWeekday]!.containsKey(anime.updateTime)) {
        groupedAnime[anime.updateWeekday]![anime.updateTime] = [];
      }
      groupedAnime[anime.updateWeekday]![anime.updateTime]!.add(anime);
    }
  }

  return groupedAnime;
}

bool isAnimeCompleted(AnimeModel anime) {
  return getShouldUpdateEpisodes(anime) == anime.totalEpisode;
}
