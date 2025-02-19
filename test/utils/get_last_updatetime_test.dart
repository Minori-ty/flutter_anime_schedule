import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import '../anime.dart';

void main() {
  test("获取最后一集的更新时间1", () {
    updateTimeBeforeWeekday.createdAt = DateTime(2025, 2, 19, 11, 0);
    DateTime firstUpdateTime = getLastEpisodeTime(updateTimeBeforeWeekday);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-20 14:30");
  });
  test("获取最后一集的更新时间2", () {
    updateTimeAfterWeekday.createdAt = DateTime(2025, 2, 19, 11, 0);
    DateTime firstUpdateTime = getLastEpisodeTime(updateTimeAfterWeekday);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-18 14:30");
  });
  test("获取最后一集的更新时间3", () {
    updateTimeBeforeUpdateTime.createdAt = DateTime(2025, 2, 19, 11, 0);
    DateTime firstUpdateTime = getLastEpisodeTime(updateTimeBeforeUpdateTime);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-19 20:00");
  });
  test("获取最后一集的更新时间4", () {
    updateTimeAfterUpdateTime.createdAt = DateTime(2025, 2, 19, 11, 0);
    DateTime firstUpdateTime = getLastEpisodeTime(updateTimeAfterUpdateTime);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-26 04:00");
  });
}
