import 'package:flutter_anime_schedule/src/models/anime_model.dart';

/// 根据番剧信息计算第一集的更新时间
/// 返回格式：YYYY-MM-DD HH:mm
String getFirstEpisodeTime(AnimeModel anime) {
  // 将更新周转换为整数表示
  int updateWeekdayday = convertWeekdayToInt(anime.updateWeekday);

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

  if (createdAt.weekday < updateWeekdayday ||
      (createdAt.weekday == updateWeekdayday &&
          createdAt.isBefore(updateTime))) {
    // 当前周还没有更新
    offsetWeeks = anime.currentEpisode;
    date = createdAt
        .subtract(Duration(days: createdAt.weekday - updateWeekdayday));
  } else {
    // 当前周已经更新
    offsetWeeks = anime.currentEpisode - 1;
    date = createdAt
        .subtract(Duration(days: createdAt.weekday - updateWeekdayday));
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

/// 判断番剧是否已经完结，返回 true or false
bool isAnimeCompleted(AnimeModel anime) {
  String firstEpisodeTimeString = getFirstEpisodeTime(anime);
  DateTime firstEpisodeTime = parseDateTime(firstEpisodeTimeString);

  DateTime now = DateTime.now();
  Duration difference = now.difference(firstEpisodeTime);
  int totalDurationInMinutes = (anime.totalEpisode - 1) * 7 * 24 * 60;

  return difference.inMinutes >= totalDurationInMinutes;
}

/// 获取本周需要更新/已经更新了的集数
int getCurrentWeekUpdatedEpisodes(AnimeModel anime) {
  // 获取第一集的时间
  String firstEpisodeTimeString = getFirstEpisodeTime(anime);
  DateTime firstEpisodeTime = parseDateTime(firstEpisodeTimeString);

  // 获取当前时间
  DateTime now = DateTime.now();

  // 初始化已更新的集数
  int updatedEpisodes = 1;

  // 每周一周一周地加，直到时间在现在的时间的本周内
  while (!isDateInTargetWeek(
      DateCheckModel(target: now, date: firstEpisodeTime))) {
    // 时间+7天
    firstEpisodeTime = firstEpisodeTime.add(Duration(days: 7));
    // 已更新的集数++
    updatedEpisodes++;

    // 如果超过了总集数，则返回总集数
    if (updatedEpisodes > anime.totalEpisode) {
      return anime.totalEpisode;
    }
  }

  return updatedEpisodes;
}

/// 计算已经更新的集数
int getUpdatedEpisodes(AnimeModel anime) {
  // 获取第一集的时间
  String firstEpisodeTimeString = getFirstEpisodeTime(anime);
  DateTime firstEpisodeTime = parseDateTime(firstEpisodeTimeString);

  // 获取当前时间
  DateTime now = DateTime.now();

  // 初始化已更新的集数
  int updatedEpisodes = 1;

  // 每周一周一周地加，直到加到本周
  while (
      firstEpisodeTime.isBefore(now) && updatedEpisodes < anime.totalEpisode) {
    firstEpisodeTime = firstEpisodeTime.add(Duration(days: 7));
    if (firstEpisodeTime.isBefore(now)) {
      updatedEpisodes++;
    }
  }

  return updatedEpisodes > anime.totalEpisode
      ? anime.totalEpisode
      : updatedEpisodes;
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
    if (isLastUpdateInThisWeekOrLater(anime)) {
      if (!groupedAnime[anime.updateWeekday]!.containsKey(anime.updateTime)) {
        groupedAnime[anime.updateWeekday]![anime.updateTime] = [];
      }
      groupedAnime[anime.updateWeekday]![anime.updateTime]!.add(anime);
    }
  }

  return groupedAnime;
}

/// 判断当前时间是否已经到了更新时间点，本周未到则返回 false，到了或者超过则返回 true
bool isUpdateTimeReached(AnimeModel anime) {
  DateTime now = DateTime.now();
  int currentWeekday = now.weekday;
  int updateWeekdayday = convertWeekdayToInt(anime.updateWeekday);

  if (currentWeekday < updateWeekdayday) {
    return false;
  } else if (currentWeekday > updateWeekdayday) {
    return true;
  } else {
    // currentWeekday == updateWeekdayday
    List<String> timeParts = anime.updateTime.split(':');
    DateTime updateTimeToday = DateTime(now.year, now.month, now.day,
        int.parse(timeParts[0]), int.parse(timeParts[1]));
    return now.isAfter(updateTimeToday) ||
        now.isAtSameMomentAs(updateTimeToday);
  }
}

class DateCheckModel {
  DateTime target;
  DateTime date;

  DateCheckModel({required this.target, required this.date});
}

/// 判断date是否属于target所属的那周
bool isDateInTargetWeek(DateCheckModel model) {
  DateTime target = model.target;
  DateTime date = model.date;

  // 获取target所属周的开始日期（周一）
  DateTime startOfWeek = target.subtract(Duration(days: target.weekday - 1));

  // 获取target所属周的结束日期（周日）
  DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

  // 判断date是否在target所属的那周
  return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
      date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
}

/// 根据番剧信息计算最后一集的更新时间
DateTime getLastUpdateDate(AnimeModel anime) {
  // 获取第一集的更新时间并解析为DateTime对象
  DateTime firstEpisodeDate = DateTime.parse(getFirstEpisodeTime(anime));

  // 计算最后一集的日期
  DateTime lastEpisodeDate =
      firstEpisodeDate.add(Duration(days: (anime.totalEpisode - 1) * 7));

  // 设置最后一集的时间
  lastEpisodeDate = DateTime(
    lastEpisodeDate.year,
    lastEpisodeDate.month,
    lastEpisodeDate.day,
    firstEpisodeDate.hour,
    firstEpisodeDate.minute,
  );

  return lastEpisodeDate;
}

/// 判断番剧的最后更新日期是否在本周及以后
bool isLastUpdateInThisWeekOrLater(AnimeModel anime) {
  // 获取当前日期
  DateTime now = DateTime.now();

  // 获取本周的周一日期
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

  // 获取最后更新日期
  DateTime lastUpdateDate = getLastUpdateDate(anime);

  // 判断最后更新日期是否在本周及以后
  return lastUpdateDate.isAfter(startOfWeek) ||
      lastUpdateDate.isAtSameMomentAs(startOfWeek);
}
