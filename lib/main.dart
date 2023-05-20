import 'dictionary.dart';
import 'translation.dart';
import 'splashscreen.dart';
import 'ocrtext.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const String _title = 'A good dictionary';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: SplashScreen(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const DictionaryScreen(),
    const TranslatorPage(),
    const OCRText(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'OCR',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.deepOrangeAccent,
        backgroundColor: const Color.fromARGB(255, 1, 40, 71),
        onTap: _onItemTapped,
      ),
      
    );
  }
}

class BackgroundImageFb1 extends StatelessWidget {
  final Widget child;
  final String imageUrl;
  const BackgroundImageFb1(
      {required this.child, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Place as the child widget of a scaffold
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
