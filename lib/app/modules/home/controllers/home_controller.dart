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

  // List of titles for each tab
  final List<String> tabTitles = [
    "Al-Qur'an", // Home tab
    "Prayer Time", // Prayer Time tab
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
    } else {
      // Filter Surah
      filteredSurah.value =
          allSurah.where((surah) {
            return surah.name.transliteration.id.toLowerCase().contains(
                  searchQuery.value,
                ) ||
                surah.name.translation.id.toLowerCase().contains(
                  searchQuery.value,
                ) ||
                surah.number.toString().contains(searchQuery.value);
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
    int juz = 1;

    List<Map<String, dynamic>> verseHolder = [];

    for (var i = 1; i <= 114; i++) {
      var res = await http.get(
        Uri.parse('https://api.quran.gading.dev/surah/$i'),
      );
      Map<String, dynamic> rawData = json.decode(res.body)['data'];
      SurahDetail data = SurahDetail.fromJson(rawData);
      for (var ayat in data.verses) {
        if (ayat.meta.juz == juz) {
          verseHolder.add({"surah": data, "ayat": ayat});
        } else {
          allJuz.add({
            "juz": juz,
            "start": verseHolder[0],
            "end": verseHolder[verseHolder.length - 1],
            "verses": verseHolder,
          });
          juz++;
          verseHolder = [];
          verseHolder.add({"surah": data, "ayat": ayat});
        }
      }
    }

    allJuz.add({
      "juz": juz,
      "start": verseHolder[0],
      "end": verseHolder[verseHolder.length - 1],
      "verses": verseHolder,
    });

    // Set allJuzDataLoaded to true and refresh bookmarks
    allJuzDataLoaded.value = true;
    await loadBookmarks(); // Refresh bookmarks after allJuz is loaded

    return allJuz;
  }
}
