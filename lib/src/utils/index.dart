import 'package:intl/intl.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';

// 获取第一集的更新时间
DateTime getFirstEpisodeTime(AnimeModel anime) {
  // 解析更新时间和当前日期
  DateTime currentDate = DateTime.now();
  DateTime updateTime = _parseUpdateTime(anime.updateTime);

  // 判断当前集数和更新时间的关系
  int weekDay = _getWeekDay(anime.updateWeek);
  DateTime firstUpdateTime =
      _getFirstUpdateTime(currentDate, updateTime, weekDay);

  return firstUpdateTime;
}

DateTime _parseUpdateTime(String updateTime) {
  // 解析字符串中的更新时间，假设格式是 "HH:mm"
  List<String> timeParts = updateTime.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day, hour, minute);
}

int _getWeekDay(String updateWeek) {
  // 根据更新星期转换为具体的星期几
  switch (updateWeek.toLowerCase()) {
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
      throw ArgumentError('Invalid updateWeek value');
  }
}

DateTime _getFirstUpdateTime(
    DateTime currentDate, DateTime updateTime, int weekDay) {
  // 计算第一集的更新时间
  int daysToAdd = (weekDay - currentDate.weekday + 7) % 7; // 计算距离下次更新时间的天数
  DateTime firstUpdate = currentDate.add(Duration(days: daysToAdd));

  // 如果 `createdAt` 比 `updateTime` 晚，说明当前集已经更新
  if (currentDate.isAfter(updateTime)) {
    // 更新的时间在今天，currentEpisode是这周的
    firstUpdate = firstUpdate
        .add(Duration(hours: updateTime.hour, minutes: updateTime.minute));
  } else {
    // `createdAt` 比 `updateTime` 早，当前集数是上周的
    firstUpdate = firstUpdate.subtract(Duration(days: 7)); // 上周的时间
    firstUpdate = firstUpdate
        .add(Duration(hours: updateTime.hour, minutes: updateTime.minute));
  }

  return firstUpdate;
}

// 格式化时间输出为YYYY-MM-DD HH:mm
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

// 获取当前集数
int getCurrentEpisodeThisWeek(AnimeModel anime) {
  // 获取第一集的更新时间
  DateTime firstEpisodeTime = getFirstEpisodeTime(anime);

  // 计算当前时间与第一集时间的差距
  DateTime currentDate = DateTime.now();

  // 如果第一集时间还在未来，返回 0 集
  if (currentDate.isBefore(firstEpisodeTime)) {
    return 0;
  }

  // 计算从第一集时间开始，经过多少个更新周期
  Duration difference = currentDate.difference(firstEpisodeTime);
  int weeksPassed = (difference.inDays / 7).floor(); // 计算过了多少周

  // 返回应该更新到的集数
  return anime.currentEpisode + weeksPassed;
}

// 判断是否完结
String getAnimeStatus(AnimeModel anime) {
  // 获取当前应该更新到的集数
  int currentEpisode = getCurrentEpisodeThisWeek(anime);

  // 判断是连载中还是已完结
  if (currentEpisode < anime.totalEpisode) {
    return "连载中";
  } else {
    return "已完结";
  }
}
