import 'dart:developer';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Audio Player',
      home: Player(),
    );
  }
}

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final player = AudioPlayer();
  Duration? duration = const Duration();

  bool isPlaying = false;
  double value = 0;

  void initPlayer() async {
    await player.setSource(AssetSource("ya_nafsu.mp3"));
    log(player.getDuration().toString());
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black38,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "assets/cover.jpg",
                    width: 250,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Name",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 3),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()} : ${(value % 60).floor()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Slider.adaptive(
                      min: 0,
                      max: duration!.inSeconds.toDouble(),
                      value: value,
                      onChanged: (newValue) {},
                      onChangeEnd: (newValue) {
                        setState(() {
                          value = newValue;
                        });
                        player.pause();
                        player.seek(Duration(seconds: value.toInt()));
                        player.resume();
                      },
                      activeColor: Colors.white,
                    ),
                  ),
                  Text(
                    "${duration!.inMinutes} : ${duration!.inSeconds.remainder(60)}",
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.pink),
                  color: Colors.black87,
                ),
                child: InkWell(
                  onTap: () async {
                    if (isPlaying) {
                      await player.pause();
                    } else {
                      await player.resume();
                    }
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    duration = await player.getDuration();
                    player.onPositionChanged.listen((position) {
                      setState(() {
                        value = position.inSeconds.toDouble();
                      });
                    });
                  },
                  child: Icon(
                    size: 50,
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
