// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:alquran_app/app/data/db/bookmark.dart';
import 'package:alquran_app/app/data/models/surah.dart';
import 'package:alquran_app/app/data/models/surah_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  List<Map<String, dynamic>> allJuz = [];
  final selectedNavIndex = 0.obs;
  RxBool allJuzDataLoaded = false.obs;

  // Add reactive list for bookmarks
  RxList<Map<String, dynamic>> bookmarkList = <Map<String, dynamic>>[].obs;

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<Surah> filteredSurah = <Surah>[].obs;
  RxList<Map<String, dynamic>> filteredJuz = <Map<String, dynamic>>[].obs;

  // List of titles for each tab
  final List<String> tabTitles = [
    "Al-Qur'an", // Home tab
    "Waktu Sholat", // Prayer Time tab
    "Bookmark", // Bookmark tab
  ];

  // Getter to get current title based on selected index
  String get currentTitle => tabTitles[selectedNavIndex.value];

  DatabaseManager database = DatabaseManager.instance;

  @override
  void onInit() {
    super.onInit();
    // Load bookmarks when controller initializes
    loadBookmarks();
    // Initialize search listener
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  // Search functionality
  void _onSearchChanged() {
    searchQuery.value = searchController.text.toLowerCase();
    _filterData();
  }

  void _filterData() {
    if (searchQuery.value.isEmpty) {
      filteredSurah.value = allSurah;
      filteredJuz.value = allJuz;
    } else {
      String query = searchQuery.value.toLowerCase();

      // Filter Surah
      filteredSurah.value =
          allSurah.where((surah) {
            return surah.name.transliteration.id.toLowerCase().contains(
                  searchQuery.value,
                ) ||
                surah.number.toString().contains(searchQuery.value);
          }).toList();

      //  Filter Juz
      filteredJuz.value =
          allJuz.where((juz) {
            try {
              String juzNumber = juz['juz'].toString();

              // Safely access nested properties
              String startSurah = '';
              String endSurah = '';

              // Check if start and end exist and have the expected structure
              if (juz['start'] != null && juz['start']['surah'] != null) {
                var startSurahData = juz['start']['surah'];
                if (startSurahData is SurahDetail) {
                  startSurah =
                      startSurahData.name.transliteration.id.toLowerCase();
                }
              }

              if (juz['end'] != null && juz['end']['surah'] != null) {
                var endSurahData = juz['end']['surah'];
                if (endSurahData is SurahDetail) {
                  endSurah = endSurahData.name.transliteration.id.toLowerCase();
                }
              }

              // Enhanced matching logic
              bool matchesJuzNumber = juzNumber.contains(query);
              bool matchesJuzText = "juz $juzNumber".contains(
                query,
              ); // "juz 1", "juz 15", etc.
              bool matchesStartSurah = startSurah.contains(query);
              bool matchesEndSurah = endSurah.contains(query);

              // Special handling for "juz" keyword
              bool matchesJuzKeyword = false;
              if (query.startsWith('juz')) {
                // Extract number after "juz "
                String juzQuery = query.replaceFirst('juz', '').trim();
                if (juzQuery.isEmpty) {
                  // If just "juz", show all juz
                  matchesJuzKeyword = true;
                } else {
                  // If "juz 1", "juz 15", etc.
                  matchesJuzKeyword = juzNumber == juzQuery;
                }
              }

              return matchesJuzNumber ||
                  matchesJuzText ||
                  matchesStartSurah ||
                  matchesEndSurah ||
                  matchesJuzKeyword;
            } catch (e) {
              // If there's any error accessing the properties, exclude this juz from results
              print('Error filtering juz: $e');
              return false;
            }
          }).toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _filterData();
  }

  // Method to load bookmarks and update reactive list
  Future<void> loadBookmarks() async {
    try {
      List<Map<String, dynamic>> bookmarks = await getBookmark();
      bookmarkList.value = bookmarks;
    } catch (e) {
      // print('Error loading bookmarks: $e');
      bookmarkList.value = [];
    }
  }

  // get all bookmark
  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmarks = await db.query(
      "bookmark",
      where: "last_read = 0",
      orderBy: "juz, via, surah, ayat",
    );
    return allBookmarks;
  }

  // delete bookmark
  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");

    // Refresh bookmark list after deletion
    await loadBookmarks();

    update();
    Get.back();
    Get.snackbar(
      "Sukses",
      "Bookmark telah dihapus",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 16,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // get last read
  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> lastReadData = await db.query(
      "bookmark",
      where: "last_read = 1",
    );

    if (lastReadData.isNotEmpty) {
      return lastReadData[0];
    } else {
      return null;
    }
  }

  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');
    var res = await http.get(url);

    List? data = (json.decode(res.body) as Map<String, dynamic>)['data'];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      filteredSurah.value = allSurah; // Initialize filtered list
      return allSurah;
    }
  }

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    // Return cached data if already loaded
    if (allJuzDataLoaded.value && allJuz.isNotEmpty) {
      return allJuz;
    }

    // Set loading state at the beginning
    allJuzDataLoaded.value = false;

    try {
      // Use a Map to group verses by Juz number
      Map<int, List<Map<String, dynamic>>> juzMap = {};

      for (var i = 1; i <= 114; i++) {
        try {
          var res = await http
              .get(Uri.parse('https://api.quran.gading.dev/surah/$i'))
              .timeout(const Duration(seconds: 10));

          if (res.statusCode != 200) {
            print('Failed to fetch surah $i: ${res.statusCode}');
            continue;
          }

          var responseBody = json.decode(res.body);
          if (responseBody == null || responseBody['data'] == null) {
            print('Invalid response for surah $i');
            continue;
          }

          Map<String, dynamic> rawData = responseBody['data'];
          SurahDetail data = SurahDetail.fromJson(rawData);

          if (data.verses.isEmpty) {
            print('No verses found for surah $i');
            continue;
          }

          for (var ayat in data.verses) {
            try {
              // Multiple null checks and safe access
              dynamic juzValue = ayat.meta.juz;
              int? juzNumber;

              if (juzValue != null) {
                if (juzValue is int) {
                  juzNumber = juzValue;
                } else if (juzValue is String) {
                  juzNumber = int.tryParse(juzValue);
                } else {
                  // Try to convert to string first, then parse
                  juzNumber = int.tryParse(juzValue.toString());
                }
              }

              // Skip if juz is null or invalid
              if (juzNumber == null || juzNumber < 1 || juzNumber > 30) {
                print(
                  'Invalid juz number for surah $i, ayat ${ayat.number}: $juzValue',
                );
                continue;
              }

              // Initialize the list for this juz if it doesn't exist
              if (!juzMap.containsKey(juzNumber)) {
                juzMap[juzNumber] = [];
              }

              // Add the verse to the appropriate juz
              juzMap[juzNumber]!.add({"surah": data, "ayat": ayat});
            } catch (ayatError) {
              print('Error processing ayat in surah $i: $ayatError');
              continue; // Skip this ayat and continue with the next one
            }

            // Add small delay to avoid overwhelming the API
            if (i % 10 == 0) {
              await Future.delayed(Duration(milliseconds: 100));
            }
          }
        } catch (surahError) {
          print('Error processing surah $i: $surahError');
          continue; // Skip this surah and continue with the next one
        }
      }

      // Convert the map to the expected list format
      allJuz.clear(); // Clear existing data

      for (int juzNumber = 1; juzNumber <= 30; juzNumber++) {
        if (juzMap.containsKey(juzNumber) && juzMap[juzNumber]!.isNotEmpty) {
          List<Map<String, dynamic>> verses = juzMap[juzNumber]!;

          allJuz.add({
            "juz": juzNumber,
            "start": verses.first,
            "end": verses.last,
            "verses": verses,
          });
        }
      }

      print('Successfully loaded ${allJuz.length} Juz parts');

      // Set allJuzDataLoaded to true and refresh bookmarks
      allJuzDataLoaded.value = true;
      filteredJuz.value = allJuz; // Initialize filtered Juz list
      await loadBookmarks(); // Refresh bookmarks after allJuz is loaded

      return allJuz;
    } catch (e, stackTrace) {
      // Set loading state to false if there's an error
      allJuzDataLoaded.value = false;

      // Detailed error logging
      print('Error in getAllJuz: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        "Error",
        "Failed to load Juz data. Please check your internet connection and try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      return [];
    }
  }
}
