import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FloorplanPage(),
    );
  }
}

class FloorplanPage extends StatefulWidget {
  @override
  _FloorplanPageState createState() => _FloorplanPageState();
}

class _FloorplanPageState extends State<FloorplanPage> {
  double _scale = 1.0;
  late Offset _focalPoint;
  Offset _offset = Offset.zero;
  List<Marker> _markers = [];
  late ScaleGestureRecognizer _scaleGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _scaleGestureRecognizer = ScaleGestureRecognizer()
      ..onUpdate = _handleScaleUpdate
      ..onStart = _handleScaleStart;
  }

  @override
  void dispose() {
    _scaleGestureRecognizer.dispose();
    super.dispose();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _focalPoint = details.focalPoint;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = details.scale;
      _offset = details.focalPoint - _focalPoint;
    });
  }

  void _handleLongPress() {
    setState(() {
      _scale = 2.0;
    });
  }

  void _handleTap(TapUpDetails details) {
    setState(() {
      _markers.add(Marker(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Test map floorplan"),
      ),
      body: Center(
        child: GestureDetector(
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onLongPress: _handleLongPress,
          onTapUp: _handleTap,
          child: Transform.scale(
            scale: _scale,
            //child: Transform.translate(
            // offset: _offset,
            child: Stack(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/floorplan.svg',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
                ..._markers.map((marker) => Positioned(
                      left: marker.x,
                      top: marker.y,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                    )),
              ],
            ),
            // ),
          ),
        ),
      ),
    );
  }
}

class Marker {
  final double x;
  final double y;

  Marker({
    required this.x,
    required this.y,
  });
}
