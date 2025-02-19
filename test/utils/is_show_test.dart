import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';

AnimeModel updateTimeLastWeek = AnimeModel(
  name: 'Test Anime',
  updateWeekday: "周一", // 周四
  updateTime: '14:30',
  currentEpisode: 1,
  totalEpisode: 1,
  cover: 'http://example.com/cover.jpg',
);
AnimeModel updateTimeThisWeek = AnimeModel(
  name: 'Test Anime',
  updateWeekday: "周一", // 周四
  updateTime: '14:30',
  currentEpisode: 1,
  totalEpisode: 1,
  cover: 'http://example.com/cover.jpg',
);

void main() {
  test("还没更新1", () {
    updateTimeLastWeek.createdAt = DateTime.now().subtract(Duration(days: 7));
    bool flag = isShowInThisWeek(updateTimeLastWeek);
    // 断言结果
    expect(flag, false);
  });
  test("已经更新1", () {
    bool flag = isShowInThisWeek(updateTimeThisWeek);
    // 断言结果
    expect(flag, true);
  });
}
