import 'package:flutter/material.dart';
import 'package:flutter_anime_schedule/src/models/anime_model.dart';
import 'package:flutter_anime_schedule/src/services/anime_service.dart';

class AnimeFormPage extends StatefulWidget {
  const AnimeFormPage({super.key});

  @override
  AnimeFormPageState createState() => AnimeFormPageState();
}

class AnimeFormPageState extends State<AnimeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _animeService = AnimeService();

  final TextEditingController _currentEpisodeController =
      TextEditingController();
  final TextEditingController _totalEpisodeController = TextEditingController();

  String _name = '';
  String _updateWeekday = '';
  TimeOfDay _updateTime = TimeOfDay(hour: 0, minute: 0);
  int _currentEpisode = 0;
  int _totalEpisode = 0;
  String _cover = '';

  final _updateWeekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

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

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加番剧'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
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
                    return '当前集数不能超过总集数';
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
                    return '当前集数不能超过总集数';
                  }
                  return null;
                },
                onSaved: (value) {
                  _totalEpisode = int.parse(value!);
                },
              ),
              TextFormField(
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
                child: Text('添加'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      AnimeModel newAnime = AnimeModel(
        name: _name,
        updateWeekday: _updateWeekday,
        updateTime: _formatTimeOfDay(_updateTime),
        currentEpisode: _currentEpisode,
        totalEpisode: _totalEpisode,
        cover: _cover,
      );
      var result = await _animeService.addAnime(newAnime);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['msg'])),
      );
      if (result['code'] == 200) {
        Navigator.pop(context, true);
      }
    }
  }
}
