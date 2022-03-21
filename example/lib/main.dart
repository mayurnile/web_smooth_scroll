import 'package:flutter/material.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Smooth Scroll',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers
  late ScrollController _scrollController;

  @override
  void initState() {
    // initialize scroll controllers
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Smooth Scroll'),
      ),
      body: WebSmoothScroll(
        controller: _scrollController,
        scrollOffset: 100,
        animationDuration: 600,
        curve: Curves.easeInOutCirc,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          child: _buildScrollableList(),
        ),
      ),
    );
  }

  /// Builder Functions
  ///
  ///
  Widget _buildScrollableList() => Column(
        children: List.generate(
          50,
          (index) => Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 120.0),
            color: Colors.red,
          ),
        ),
      );
}
