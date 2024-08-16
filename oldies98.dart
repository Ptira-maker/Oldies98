// Importa i pacchetti necessari
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  // Inizializza la riproduzione in background
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.radio.channel.audio',
    androidNotificationChannelName: 'Radio Playback',
    androidNotificationOngoing: true,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RadioPlayerScreen(),
    );
  }
}

class RadioPlayerScreen extends StatefulWidget {
  @override
  _RadioPlayerScreenState createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {
  // Istanzia il player
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setVolume(_volume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Funzione per gestire play/pause
  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource("http://nr14.newradio.it:8772/stream"));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Funzione per cambiare il volume
  void _changeVolume(double value) {
    setState(() {
      _volume = value;
      _audioPlayer.setVolume(_volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Radio Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 64.0,
            onPressed: _togglePlayPause,
          ),
          Slider(
            value: _volume,
            min: 0.0,
            max: 1.0,
            onChanged: _changeVolume,
          ),
          Text('Volume: ${(_volume * 100).round()}%'),
        ],
      ),
    );
  }
}