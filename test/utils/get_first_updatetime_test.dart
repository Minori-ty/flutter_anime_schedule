import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import '../anime.dart';

void main() {
  test("获取第一集的更新时间1", () {
    DateTime firstUpdateTime = getFirstEpisodeTime(updateTimeBeforeWeekday);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-06 14:30");
  });
  test("获取第一集的更新时间2", () {
    DateTime firstUpdateTime = getFirstEpisodeTime(updateTimeAfterWeekday);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-11 14:30");
  });
  test("获取第一集的更新时间3", () {
    DateTime firstUpdateTime = getFirstEpisodeTime(updateTimeBeforeUpdateTime);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-05 20:00");
  });
  test("获取第一集的更新时间4", () {
    DateTime firstUpdateTime = getFirstEpisodeTime(updateTimeAfterUpdateTime);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-12 04:00");
  });
  test("第0集时获取第一集更新时间", () {
    DateTime firstUpdateTime = getFirstEpisodeTime(updateTimeAfterNow);
    // 断言结果
    expect(formatDateTime(firstUpdateTime), "2025-02-20 04:00");
  });
}
