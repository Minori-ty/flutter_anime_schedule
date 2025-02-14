import 'package:flutter_anime_schedule/src/models/anime_model.dart';

/// 根据番剧信息计算第一集的更新时间
/// 返回格式：YYYY-MM-DD HH:mm
String getFirstEpisodeTime(AnimeModel anime) {
  // 将更新周转换为整数表示
  int updateWeekday = _convertWeekdayToInt(anime.updateWeek);

  // 获取创建日期和更新时间
  DateTime createdAt = anime.createdAt;
  DateTime updateTime = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
      int.parse(anime.updateTime.split(':')[0]),
      int.parse(anime.updateTime.split(':')[1]));

  int offsetWeeks;
  DateTime date;

  if (createdAt.weekday < updateWeekday ||
      (createdAt.weekday == updateWeekday && createdAt.isBefore(updateTime))) {
    // 当前周还没有更新
    offsetWeeks = anime.currentEpisode;
    date =
        createdAt.subtract(Duration(days: createdAt.weekday - updateWeekday));
  } else {
    // 当前周已经更新
    offsetWeeks = anime.currentEpisode - 1;
    date =
        createdAt.subtract(Duration(days: createdAt.weekday - updateWeekday));
  }

  // 计算第一集的日期
  DateTime firstEpisodeDate = date.subtract(Duration(days: offsetWeeks * 7));

  // 设置第一集的时间
  firstEpisodeDate = DateTime(
    firstEpisodeDate.year,
    firstEpisodeDate.month,
    firstEpisodeDate.day,
    updateTime.hour,
    updateTime.minute,
  );

  // 格式化日期和时间为字符串
  return formatDateTime(firstEpisodeDate);
}

/// 将更新周转换为整数表示
int _convertWeekdayToInt(String weekday) {
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

class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({
    required this.hour,
    required this.minute,
  });

  bool operator <(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }
}

/// 判断是否完结
bool isAnimeCompleted(AnimeModel anime) {
  int currentWeekEpisode = getCurrentWeekEpisode(anime);
  return currentWeekEpisode >= anime.totalEpisode;
}

/// 获取本周需要更新的集数
int getCurrentWeekEpisode(AnimeModel anime) {
  String firstEpisodeTimeString = getFirstEpisodeTime(anime);
  DateTime firstEpisodeTime = parseDateTime(firstEpisodeTimeString);

  DateTime now = DateTime.now();
  Duration difference = now.difference(firstEpisodeTime);
  int weeksSinceFirstEpisode = (difference.inDays / 7).floor() + 1;

  if (weeksSinceFirstEpisode > anime.totalEpisode) {
    return anime.totalEpisode;
  }
  return weeksSinceFirstEpisode;
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

/// 分组 AnimeModel，根据 updateWeek 和 updateTime
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
    if (!groupedAnime[anime.updateWeek]!.containsKey(anime.updateTime)) {
      groupedAnime[anime.updateWeek]![anime.updateTime] = [];
    }
    groupedAnime[anime.updateWeek]![anime.updateTime]!.add(anime);
  }

  return groupedAnime;
}

/// 判断本周是否已经到了更新时间，未到则返回 false，到了或者超过则返回 true
bool isUpdateTimeReached(AnimeModel anime) {
  DateTime now = DateTime.now();
  int updateWeekday = _convertWeekdayToInt(anime.updateWeek);
  List<String> timeParts = anime.updateTime.split(':');
  DateTime updateTimeThisWeek = DateTime(now.year, now.month, now.day,
      int.parse(timeParts[0]), int.parse(timeParts[1]));

  while (updateTimeThisWeek.weekday != updateWeekday) {
    updateTimeThisWeek = updateTimeThisWeek.add(const Duration(days: 1));
  }

  return now.isAfter(updateTimeThisWeek) ||
      now.isAtSameMomentAs(updateTimeThisWeek);
}
