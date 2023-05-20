import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({Key? key}) : super(key: key);

  @override
  _TranslatorPageState createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  String translated = 'Translation';
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  String fromLanguage = 'en';
  String toLanguage = 'vi';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _controller.text = result.recognizedWords;
    setState(() {});
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(toLanguage);
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Future<void> _translateText(String text) async {
    var translation = await text.translate(
      from: fromLanguage,
      to: toLanguage,
    );

    setState(() {
      translated = translation.text;
    });
  }

  void _switchLanguages() {
    final String tempLanguage = fromLanguage;
    fromLanguage = toLanguage;
    toLanguage = tempLanguage;
    _translateText(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.translate),
        title: const Text('Phiên dịch'),
        backgroundColor: const Color.fromARGB(255, 1, 40, 71),
      ),
      body: Card(
        margin: const EdgeInsets.all(12),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: fromLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      fromLanguage = newValue!;
                      _translateText(_controller.text);
                    });
                  },
                  items: <String>[
                    'en', // English
                    'vi', // Vietnamese
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                IconButton(
                  onPressed: _switchLanguages,
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: 'Switch Languages',
                ),
                DropdownButton<String>(
                  value: toLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      toLanguage = newValue!;
                      _translateText(_controller.text);
                    });
                  },
                  items: <String>[
                    'en', // English
                    'vi', // Vietnamese
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                suffix: IconButton(
                  onPressed: _speechToText.isListening
                      ? _stopListening
                      : _startListening,
                  icon: Icon(
                    _speechToText.isListening ? Icons.mic_off : Icons.mic,
                  ),
                ),
                hintText: 'Nhập/Nói từ',
              ),
              onChanged: (text) {
                _translateText(text);
              },
            ),
            const Divider(height: 32),
            const Text('Dịch/Translation'),
            const Text(' '),
            Text(
              translated,
              style: const TextStyle(
                fontSize: 36,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                _speak(translated);
              },
              icon: const Icon(Icons.volume_up),
              tooltip: 'Text-to-Speech',
            ),
          ],
        ),
      ),
    );
  }
}
