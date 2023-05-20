import 'dart:convert';
import 'package:flutter/material.dart';
import 'detail_screen.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<DictionaryEntry> englishEntries = [];
  List<DictionaryEntry> vietnameseEntries = [];
  bool isEnglishToVietnamese = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadDictionary();
  }

  void loadDictionary() async {
  try {
    // Load English JSON data
    String englishJsonString = await DefaultAssetBundle.of(context).loadString('assets/english_data.json');
    List<dynamic> englishJsonList = jsonDecode(englishJsonString);
    List<DictionaryEntry> englishEntriesList = englishJsonList
        .map((json) => DictionaryEntry.fromJson(json as Map<String, dynamic>))
        .toList();

    // Load Vietnamese JSON data
    String vietnameseJsonString = await DefaultAssetBundle.of(context).loadString('assets/vietnamese_data.json');
    List<dynamic> vietnameseJsonList = jsonDecode(vietnameseJsonString);
    List<DictionaryEntry> vietnameseEntriesList = vietnameseJsonList
        .map((json) => DictionaryEntry.fromJson(json as Map<String, dynamic>))
        .toList();

    setState(() {
      englishEntries = englishEntriesList;
      vietnameseEntries = vietnameseEntriesList;
    });
  } catch (e) {
    // Handle error
    print('Error loading dictionary: $e');
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
              onPressed: toggleLanguage,
              child: Text(
                isEnglishToVietnamese ? 'Vietnamese - English' : 'English - Vietnamese',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
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