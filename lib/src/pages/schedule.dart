import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_anime_schedule/src/conponents/tab_appbar.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<Map<String, Map<String, List<AnimeModel>>>> _groupedAnimes;

  @override
  void initState() {
    super.initState();
    _groupedAnimes = _fetchAndGroupAnimes();
  }

  Future<Map<String, Map<String, List<AnimeModel>>>>
      _fetchAndGroupAnimes() async {
    AnimeService animeService = AnimeService();
    Map<String, dynamic> response = await animeService.getAnimes();
    if (response['code'] == 200) {
      List<AnimeModel> animes = List<AnimeModel>.from(response['data']);
      return groupAnimeByWeekAndTime(animes);
    } else {
      return Future.error('Failed to load animes');
    }
  }

  Future<void> _refreshAnimes() async {
    setState(() {
      _groupedAnimes = _fetchAndGroupAnimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentDayOfWeek = (DateTime.now().weekday - 1) % 7;

    return DefaultTabController(
      length: 7,
      initialIndex: currentDayOfWeek,
      child: Scaffold(
        appBar: TabAppBar(
          tabs: const [
            Tab(text: '周一'),
            Tab(text: '周二'),
            Tab(text: '周三'),
            Tab(text: '周四'),
            Tab(text: '周五'),
            Tab(text: '周六'),
            Tab(text: '周日'),
          ],
        ),
        body: FutureBuilder<Map<String, Map<String, List<AnimeModel>>>>(
          future: _groupedAnimes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshAnimes,
                child: ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.6, // Adjust the height as needed
                      child: Center(
                        child: Lottie.asset(
                            'assets/lottie/empty.json'), // Display Lottie animation
                      ),
                    ),
                  ],
                ),
              );
            } else {
              var groupedAnimes = snapshot.data!;
              return TabBarView(
                children: [
                  _buildAnimeList(groupedAnimes['周一']!),
                  _buildAnimeList(groupedAnimes['周二']!),
                  _buildAnimeList(groupedAnimes['周三']!),
                  _buildAnimeList(groupedAnimes['周四']!),
                  _buildAnimeList(groupedAnimes['周五']!),
                  _buildAnimeList(groupedAnimes['周六']!),
                  _buildAnimeList(groupedAnimes['周日']!),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildAnimeList(Map<String, List<AnimeModel>> animeMap) {
    var sortedTimes = animeMap.keys.toList()..sort();
    if (sortedTimes.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshAnimes,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6, // Adjust the height as needed
              child: Center(
                child: Lottie.asset(
                    'assets/lottie/empty.json'), // Display Lottie animation
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refreshAnimes,
      child: ListView.builder(
        itemCount: sortedTimes.length,
        itemBuilder: (context, index) {
          String time = sortedTimes[index];
          List<AnimeModel> animes = animeMap[time]!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60,
                  child: Text(time,
                      style: const TextStyle(
                        fontSize: 15,
                      )),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: animes.map((anime) {
                      double width = 70;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width,
                              height: width * 3 / 2,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: anime.cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    anime.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${isUpdateInThisWeek(anime) ? '更新到' : "即将更新"} 第${getShouldUpdateEpisodes(anime)}集',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isUpdateInThisWeek(anime)
                                        ? Colors.pinkAccent[200]
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
