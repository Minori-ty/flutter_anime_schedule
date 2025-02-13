import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:intl/intl.dart';

String getFirstEpisodeTime(AnimeModel anime) {
  // Create a map to convert Chinese week days to integers
  const weekDays = {
    '周一': 1,
    '周二': 2,
    '周三': 3,
    '周四': 4,
    '周五': 5,
    '周六': 6,
    '周日': 7,
  };

  // Get the necessary fields from the AnimeModel
  final createdAt = anime.createdAt;
  final updateWeek = anime.updateWeek;
  final updateTime = anime.updateTime;
  final currentEpisode = anime.currentEpisode;

  // Calculate the day difference between `createdAt` and `updateWeek`
  final createdWeekDay = createdAt.weekday;
  final targetWeekDay = weekDays[updateWeek] ?? 1;

  // Calculate the time difference between `createdAt` and `updateTime`
  final createdTime = TimeOfDay(
    hour: createdAt.hour,
    minute: createdAt.minute,
  );
  final updateDateTime = DateTime(
    createdAt.year,
    createdAt.month,
    createdAt.day,
    int.parse(updateTime.split(':')[0]),
    int.parse(updateTime.split(':')[1]),
  );
  final updateTimeOfDay = TimeOfDay(
    hour: updateDateTime.hour,
    minute: updateDateTime.minute,
  );

  // Determine the number of weeks to go back
  int weeksBack;
  if (createdWeekDay < targetWeekDay ||
      (createdWeekDay == targetWeekDay && createdTime < updateTimeOfDay)) {
    weeksBack = currentEpisode;
  } else {
    weeksBack = currentEpisode - 1;
  }

  // Calculate the date of the first episode
  final firstEpisodeDate = createdAt
      .subtract(Duration(days: weeksBack * 7))
      .subtract(Duration(days: createdWeekDay - targetWeekDay));

  // Combine the date of the first episode with the update time
  final firstEpisodeDateTime = DateTime(
    firstEpisodeDate.year,
    firstEpisodeDate.month,
    firstEpisodeDate.day,
    int.parse(updateTime.split(':')[0]),
    int.parse(updateTime.split(':')[1]),
  );

  // Format the result to 'YYYY-MM-DD HH:mm'
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  return formatter.format(firstEpisodeDateTime);
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

// 判断是否完结
bool isAnimeCompleted(AnimeModel anime) {
  final firstEpisodeTimeString = getFirstEpisodeTime(anime);
  final DateTime firstEpisodeTime =
      DateFormat('yyyy-MM-dd HH:mm').parse(firstEpisodeTimeString);

  // Calculate the date of the last episode
  final lastEpisodeDateTime =
      firstEpisodeTime.add(Duration(days: (anime.totalEpisode - 1) * 7));

  // Get the current date and time
  final currentDateTime = DateTime.now();

  // Check if the last episode date and time has passed
  return currentDateTime.isAfter(lastEpisodeDateTime);
}

// 获取本周需要更新的集数
int getEpisodesToUpdateThisWeek(AnimeModel anime) {
  final firstEpisodeTimeString = getFirstEpisodeTime(anime);
  final DateTime firstEpisodeTime =
      DateFormat('yyyy-MM-dd HH:mm').parse(firstEpisodeTimeString);

  // Get the current date and time
  final currentDateTime = DateTime.now();

  // Calculate the number of weeks from the first episode to the current date
  final weeksPassed = currentDateTime.difference(firstEpisodeTime).inDays ~/ 7;

  // Calculate the number of episodes that should be updated by this week
  final episodesToUpdate = weeksPassed + 1;

  // If the episodes to update exceed total episodes, return total episodes
  if (episodesToUpdate > anime.totalEpisode) {
    return anime.totalEpisode;
  }

  return episodesToUpdate;
}
