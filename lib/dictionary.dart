import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_screen.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<DictionaryEntry> englishEntries = [];
  List<DictionaryEntry> vietnameseEntries = [];
  bool isEnglishToVietnamese = true;
  String searchQuery = '';
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadDictionary();
  }

  void loadDictionary() async {
    setState(() {
      isLoading = true;
    });

    try {
      final englishResponse = await http.get(Uri.parse('http://10.0.2.2:8000/english'));
      final vietnameseResponse = await http.get(Uri.parse('http://10.0.2.2:8000/vietnamese'));

      if (englishResponse.statusCode == 200 && vietnameseResponse.statusCode == 200) {
        final englishJsonList = jsonDecode(englishResponse.body) as List<dynamic>;
        final vietnameseJsonList = jsonDecode(vietnameseResponse.body) as List<dynamic>;

        final englishEntriesList = englishJsonList
            .map((json) => DictionaryEntry.fromJson(json as Map<String, dynamic>))
            .toList();
        final vietnameseEntriesList = vietnameseJsonList
            .map((json) => DictionaryEntry.fromJson(json as Map<String, dynamic>))
            .toList();

        setState(() {
          englishEntries = englishEntriesList;
          vietnameseEntries = vietnameseEntriesList;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load dictionary';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading dictionary: $e';
        isLoading = false;
      });
    }
  }

  void toggleLanguage() {
    setState(() {
      isEnglishToVietnamese = !isEnglishToVietnamese;
    });
  }

  void setSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<DictionaryEntry> getCurrentLanguageEntries() {
    return isEnglishToVietnamese ? englishEntries : vietnameseEntries;
  }

  List<DictionaryEntry> getFilteredEntries() {
    List<DictionaryEntry> currentLanguageEntries = getCurrentLanguageEntries();
    if (searchQuery.isEmpty) {
      return currentLanguageEntries;
    } else {
      return currentLanguageEntries
          .where((entry) =>
              entry.word.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DictionaryEntry> filteredEntries = getFilteredEntries();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 40, 71),
        title: const Text('A Good Dictionary'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: setSearchQuery,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: isLoading ? null : toggleLanguage,
              child: Text(
                isEnglishToVietnamese ? 'Vietnamese - English' : 'English - Vietnamese',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        filteredEntries[index].word,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        filteredEntries[index].description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              entry: filteredEntries[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class DictionaryEntry {
  final String word;
  final String description;
  final String pronounce;
  final String image;

  DictionaryEntry({
    required this.word,
    required this.description,
    required this.pronounce,
    required this.image,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      word: json['word'] ?? '',
      description: json['description'] ?? '',
      pronounce: json['pronounce'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'description': description,
      'pronounce': pronounce,
      'image': image,
    };
  }
}
