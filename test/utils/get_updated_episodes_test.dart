import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import '../anime.dart';

void main() {
  test("获取应该更新的集数1", () {
    int episodes = getUpdatedEpisodes(updateTimeBeforeWeekday);
    // 断言结果
    expect(episodes, 2);
  });
  test("获取应该更新的集数2", () {
    int episodes = getUpdatedEpisodes(updateTimeAfterWeekday);
    // 断言结果
    expect(episodes, 2);
  });
  test("获取应该更新的集数3", () {
    int episodes = getUpdatedEpisodes(updateTimeBeforeUpdateTime);
    // 断言结果
    expect(episodes, 2);
  });
  test("获取应该更新的集数4", () {
    int episodes = getUpdatedEpisodes(updateTimeAfterUpdateTime);
    // 断言结果
    expect(episodes, 2);
  });
  test("获取应该更新的集数5", () {
    int episodes = getUpdatedEpisodes(updateTimeAfterNow);
    // 断言结果
    expect(episodes, 0);
  });
}
