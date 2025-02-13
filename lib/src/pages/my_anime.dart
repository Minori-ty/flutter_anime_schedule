import 'package:flutter/material.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';
import 'package:flutter_anime_schedule/src/pages/add_anime.dart';

class MyAnimePage extends StatefulWidget {
  const MyAnimePage({super.key});

  @override
  _MyAnimePageState createState() => _MyAnimePageState();
}

class _MyAnimePageState extends State<MyAnimePage> {
  final AnimeService _animeService = AnimeService();

  Future<void> _refreshAnimes() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追番列表'),
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
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: FutureBuilder(
          future: _animeService.getAnimes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              var data = snapshot.data as Map<String, dynamic>;
              var animes = data['data'] as List<AnimeModel>;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 2 / 3.5,
                ),
                itemCount: animes.length,
                itemBuilder: (context, index) {
                  var anime = animes[index];
                  return GestureDetector(
                    onLongPress: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('确认删除'),
                          content: Text('你确定要删除 "${anime.name}" 吗？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('取消'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('删除'),
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
                                  image: DecorationImage(
                                    image: NetworkImage(anime.cover),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 2.0),
                                  color: Colors.red,
                                  child: Text(
                                    '连载中',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
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
                            style: TextStyle(
                              fontSize: 12.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '第1集',
                            style: TextStyle(
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
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
