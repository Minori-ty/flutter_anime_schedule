import 'package:flutter/material.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';

class AnimeDetailPage extends StatefulWidget {
  final AnimeModel anime;

  const AnimeDetailPage({Key? key, required this.anime}) : super(key: key);

  @override
  _AnimeDetailPageState createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final AnimeService _animeService = AnimeService();

  final TextEditingController _currentEpisodeController =
      TextEditingController();
  final TextEditingController _totalEpisodeController = TextEditingController();

  late String _name;
  late String _updateWeekday;
  late TimeOfDay _updateTime;
  late int _currentEpisode;
  late int _totalEpisode;
  late String _cover;

  final List<String> _updateWeekdays = [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the values from the passed anime.
    _name = widget.anime.name;
    _updateWeekday = widget.anime.updateWeekday;
    _updateTime = _parseTime(widget.anime.updateTime);
    _currentEpisode = widget.anime.currentEpisode;
    _totalEpisode = widget.anime.totalEpisode;
    _cover = widget.anime.cover;

    _currentEpisodeController.text = _currentEpisode.toString();
    _totalEpisodeController.text = _totalEpisode.toString();
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay(hour: 0, minute: 0);
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _updateTime,
    );
    if (picked != null && picked != _updateTime) {
      setState(() {
        _updateTime = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Update the existing AnimeModel instance's properties.
      widget.anime.name = _name;
      widget.anime.updateWeekday = _updateWeekday;
      widget.anime.updateTime = _formatTimeOfDay(_updateTime);
      widget.anime.currentEpisode = _currentEpisode;
      widget.anime.totalEpisode = _totalEpisode;
      widget.anime.cover = _cover;

      // Call the AnimeService's update method.
      var result = await _animeService.updateAnime(widget.anime);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['msg'])),
      );
      if (result['code'] == 200) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('番剧详情'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: '番剧名称'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入番剧名称';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: '更新周'),
                value: _updateWeekday.isNotEmpty ? _updateWeekday : null,
                items: _updateWeekdays.map((week) {
                  return DropdownMenuItem(
                    value: week,
                    child: Text(week),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _updateWeekday = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请选择更新周';
                  }
                  return null;
                },
                onSaved: (value) {
                  _updateWeekday = value!;
                },
              ),
              ListTile(
                title: Text("更新时间点: ${_updateTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              TextFormField(
                controller: _currentEpisodeController,
                decoration: InputDecoration(labelText: '当前更新集数'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入当前更新集数';
                  }
                  final currentEpisode = int.tryParse(value);
                  final totalEpisode =
                      int.tryParse(_totalEpisodeController.text);
                  if (currentEpisode != null &&
                      totalEpisode != null &&
                      currentEpisode > totalEpisode) {
                    return '当前更新集数不能超过总集数';
                  }
                  return null;
                },
                onSaved: (value) {
                  _currentEpisode = int.parse(value!);
                },
              ),
              TextFormField(
                controller: _totalEpisodeController,
                decoration: InputDecoration(labelText: '总集数'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入总集数';
                  }
                  final currentEpisode =
                      int.tryParse(_currentEpisodeController.text);
                  final totalEpisode = int.tryParse(value);
                  if (currentEpisode != null &&
                      totalEpisode != null &&
                      currentEpisode > totalEpisode) {
                    return '当前更新集数不能超过总集数';
                  }
                  return null;
                },
                onSaved: (value) {
                  _totalEpisode = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _cover,
                decoration: InputDecoration(labelText: '封面 URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入封面 URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cover = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('更新'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
