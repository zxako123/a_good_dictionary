import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5)).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (ctx) => const MyBottomNavigationBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
            backgroundColor: Color.fromARGB(255, 1, 40, 71),
        body: SizedBox(
      width: double.infinity,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(
          image: AssetImage('assets/1.png'),
          width: 200,
        ),
        Text(
          'A good dictionary',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 50,
        ),
        SpinKitThreeBounce(
          color: Colors.deepOrangeAccent,
          size: 50.0,
        )
      ]),
    ));
  }
}
