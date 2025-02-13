import 'package:hive/hive.dart';

part 'anime_model.g.dart';

@HiveType(typeId: 0)
class AnimeModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String updateWeek; // 中文的周一到周日

  @HiveField(3)
  String updateTime; // HH:mm

  @HiveField(4)
  int currentEpisode;

  @HiveField(5)
  int totalEpisode;

  @HiveField(6)
  String cover;

  @HiveField(7)
  DateTime createdAt;

  AnimeModel({
    required this.name,
    required this.updateWeek,
    required this.updateTime,
    required this.currentEpisode,
    required this.totalEpisode,
    required this.cover,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = DateTime.now();
}
