import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Game(),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final Map<int, String> _coin = {0: 'assets/head.png', 1: 'assets/thail.png'};
  bool up = false;
  int spinning = 2;
  final _scrollController = FixedExtentScrollController();
  double width(double coaf) {
    var a = MediaQuery.of(context).size.width / 100 * coaf;
    return a;
  }

  double heigth(double coaf) {
    var a = MediaQuery.of(context).size.height / 100 * coaf;
    return a;
  }

  _start() {
    var rand = Random();
    var offset = _scrollController.offset;
    _scrollController.animateTo(
        offset +
            width(27) +
            (width(30) * (rand.nextInt(1) + 1) * (rand.nextInt(10) + 20)),
        duration: const Duration(seconds: 3),
        curve: Curves.fastEaseInToSlowEaseOut);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back1.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(196, 64, 64, 64),
          title: const Center(
            child: Text(
              'Spin the coin!',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 0, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SafeArea(
            child: Stack(children: [
          AnimatedPositioned(
            top: up ? heigth(5) : heigth(40),
            left: width(20),
            right: width(20),
            duration: up
                ? const Duration(milliseconds: 1000)
                : const Duration(milliseconds: 1500),
            curve: up ? Curves.bounceIn : Curves.bounceOut,
            onEnd: () {
              setState(() {
                up = false;
                spinning++;
              });
            },
            child: SizedBox(
              height: width(60),
              width: width(60),
              child: ListWheelScrollView.useDelegate(
                physics: const FixedExtentScrollPhysics(),
                itemExtent: width(60),
                diameterRatio: 0.0000000000000001,
                controller: _scrollController,
                childDelegate: ListWheelChildLoopingListDelegate(children: [
                  SizedBox(
                    height: width(50),
                    width: width(50),
                    child: Image.asset(_coin[0]!),
                  ),
                  SizedBox(
                    height: width(50),
                    width: width(50),
                    child: Image.asset(_coin[1]!),
                  ),
                ]),
              ),
            ),
          ),
          Positioned(
              bottom: heigth(10),
              left: width(10),
              right: width(10),
              child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  onPressed: () {
                    if (spinning == 2) {
                      setState(() {
                        up = true;
                        spinning = 0;
                      });
                      _start();
                    }
                  },
                  child: const Text(
                    'SPIN!',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  )))
        ])),
      ),
    );
  }
}
