import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dictionary.dart';

class DetailScreen extends StatefulWidget {
  final DictionaryEntry entry;

  const DetailScreen({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  FlutterTts flutterTts = FlutterTts();
  String currentLanguage = 'en-US'; // Default language is English (United States)

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> speakWord(String word) async {
    await flutterTts.setLanguage(currentLanguage);
    flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              widget.entry.word,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              'Pronunciation:',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              "/${widget.entry.pronounce}/",
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              widget.entry.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            if (widget.entry.image.isNotEmpty) // Check if image path is available
              Image.asset(
                widget.entry.image,
                height: 200,
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentLanguage = 'en-US';
                    });
                    speakWord(widget.entry.word);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: currentLanguage == 'en-US' ? Colors.green : null,
                  ),
                  child: const Text('English'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentLanguage = 'vi-VN';
                    });
                    speakWord(widget.entry.word);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: currentLanguage == 'vi-VN' ? Colors.green : null,
                  ),
                  child: const Text('Vietnamese'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}