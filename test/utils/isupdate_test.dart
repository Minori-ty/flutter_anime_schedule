import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import '../anime.dart';

void main() {
  test("还没更新1", () {
    bool flag = isUpdateInThisWeek(updateTimeBeforeWeekday);
    // 断言结果
    expect(flag, false);
  });
  test("已经更新1", () {
    bool flag = isUpdateInThisWeek(updateTimeAfterWeekday);
    // 断言结果
    expect(flag, true);
  });
  test("还没更新2", () {
    bool flag = isUpdateInThisWeek(updateTimeBeforeUpdateTime);
    // 断言结果
    expect(flag, false);
  });
  test("已经更新2", () {
    bool flag = isUpdateInThisWeek(updateTimeAfterUpdateTime);
    // 断言结果
    expect(flag, true);
  });
}
