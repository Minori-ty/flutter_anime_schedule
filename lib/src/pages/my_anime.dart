import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';
import 'package:flutter_anime_schedule/src/pages/add_anime.dart';
import 'package:flutter_anime_schedule/src/pages/anime_detail.dart';
import 'package:flutter_anime_schedule/src/utils/utils.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

class MyAnimePage extends StatefulWidget {
  const MyAnimePage({super.key});

  @override
  _MyAnimePageState createState() => _MyAnimePageState();
}

const double space = 12;

class _MyAnimePageState extends State<MyAnimePage> {
  final AnimeService _animeService = AnimeService();
  Future<Map<String, dynamic>>? _animeFuture;

  @override
  void initState() {
    super.initState();
    _fetchAnimes();
  }

  void _fetchAnimes() {
    _animeFuture = _animeService.getAnimes();
  }

  Future<void> _refreshAnimes() async {
    _fetchAnimes();
    setState(() {});
    // 等待数据加载结束，确保刷新指示器正确结束
    await _animeFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追番列表'),
        actions: [
          IconButton(
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnimeFormPage()),
              );
              if (result == true) {
                _refreshAnimes();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: space),
        // RefreshIndicator 的 child 必须是一个可滚动组件，
        // 当数据加载时或出现错误时，也返回一个 ListView，使界面始终可滚动，
        // 避免因内容不足而反复触发刷新
        child: RefreshIndicator(
          onRefresh: _refreshAnimes,
          child: FutureBuilder(
            future: _animeFuture,
            builder: (context, snapshot) {
              // 当数据正在加载时，用一个 ListView 包裹 loading 指示器
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200), // 占位，保证足够高度
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.hasError) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 200),
                    Center(child: Text('Error: ${snapshot.error}')),
                  ],
                );
              } else if (snapshot.hasData) {
                var data = snapshot.data as Map<String, dynamic>;
                var animes = data['data'] as List<AnimeModel>;
                if (animes.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                  );
                }
                return GridView.builder(
                  // 设置 AlwaysScrollableScrollPhysics 确保即使内容较少也能下拉刷新
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: space,
                    mainAxisSpacing: space,
                    childAspectRatio: 2 / 3.7,
                  ),
                  itemCount: animes.length,
                  itemBuilder: (context, index) {
                    var anime = animes[index];
                    return GestureDetector(
                      onTap: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimeDetailPage(anime: anime),
                          ),
                        );
                        if (result == true) {
                          _refreshAnimes();
                        }
                      },
                      onLongPress: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('确认删除'),
                            content: Text('你确定要删除 "${anime.name}" 吗？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('删除'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _animeService.deleteAnime(anime.id);
                          _refreshAnimes();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: isAnimeCompleted(anime)
                                          ? Colors.red
                                          : Colors.blue,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      isAnimeCompleted(anime) ? "已完结" : '连载中',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              anime.name,
                              style: const TextStyle(
                                fontSize: 12.0,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '更新 第${getUpdatedEpisodes(anime)}集',
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                // 无数据时返回一个可滚动的 ListView
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
