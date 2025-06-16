import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/color_analysis.dart';
import '../models/color_meaning.dart';
import '../models/color_palette.dart';
import '../services/gemini_service.dart';
import '../services/storage_service.dart';

enum AnalysisStatus { idle, loading, success, error }

class ColorProvider extends ChangeNotifier {
  final GeminiService _geminiService;
  final StorageService _storageService;
  
  ColorAnalysis? _currentAnalysis;
  ColorPalette? _currentPalette;
  ColorMeaning? _currentMeaning;
  String? _errorMessage;
  AnalysisStatus _status = AnalysisStatus.idle;
  List<ColorAnalysis> _savedAnalyses = [];
  List<ColorPalette> _savedPalettes = [];
  List<ColorMeaning> _savedMeanings = [];
  
  ColorProvider({
    required GeminiService geminiService,
    required StorageService storageService,
  }) : _geminiService = geminiService,
       _storageService = storageService {
    _initializeProvider();
  }

  // Initialize and migrate data if needed
  Future<void> _initializeProvider() async {
    // Clear old data structure to ensure compatibility with makeup colors
    await _migrateDataStructure();
    await _loadSavedItems();
  }

  // Migrate old data structure to support makeup colors
  Future<void> _migrateDataStructure() async {
    try {
      final existingAnalyses = _storageService.getAllColorAnalyses();
      bool needsMigration = false;
      
      // Check if any existing analyses lack makeup colors structure
      for (final analysis in existingAnalyses) {
        if (analysis.makeupColors == null) {
          needsMigration = true;
          break;
        }
      }
      
      // If migration is needed, clear old incompatible data
      if (needsMigration) {
        await _storageService.clearAllColorAnalyses();
        print('Migrated color analysis data structure to support makeup colors');
      }
    } catch (e) {
      // If there's any error, clear and start fresh
      await _storageService.clearAllColorAnalyses();
      print('Cleared color analysis data due to structure change');
    }
  }
  
  // Getters
  ColorAnalysis? get currentAnalysis => _currentAnalysis;
  ColorPalette? get currentPalette => _currentPalette;
  ColorMeaning? get currentMeaning => _currentMeaning;
  String? get errorMessage => _errorMessage;
  AnalysisStatus get status => _status;
  List<ColorAnalysis> get savedAnalyses => _savedAnalyses;
  List<ColorPalette> get savedPalettes => _savedPalettes;
  List<ColorMeaning> get savedMeanings => _savedMeanings;
  
  // Check if current analysis is saved
  bool get isCurrentAnalysisSaved {
    if (_currentAnalysis == null) return false;
    return _savedAnalyses.any((analysis) => analysis.id == _currentAnalysis!.id);
  }
  
  // Color Analysis functionality
  Future<void> analyzePersonalColorType(Uint8List imageBytes) async {
    _setLoading();
    try {
      final analysis = await _geminiService.analyzePersonalColorType(imageBytes);
      _currentAnalysis = analysis;
      _status = AnalysisStatus.success;
      notifyListeners();
    } catch (e) {
      _setError('Failed to analyze color type: ${e.toString()}');
    }
  }
  
  // Generate palette from image
  Future<void> generatePaletteFromImage(Uint8List imageBytes) async {
    _setLoading();
    try {
      final palette = await _geminiService.generatePaletteFromImage(imageBytes);
      _currentPalette = palette;
      _status = AnalysisStatus.success;
      notifyListeners();
    } catch (e) {
      _setError('Failed to generate palette: ${e.toString()}');
    }
  }
  
  // Get color psychology
  Future<void> getColorMeaning(String colorHex) async {
    _setLoading();
    try {
      final meaning = await _geminiService.getColorPsychology(colorHex);
      _currentMeaning = meaning;
      _status = AnalysisStatus.success;
      notifyListeners();
    } catch (e) {
      _setError('Failed to get color meaning: ${e.toString()}');
    }
  }
  
  // Save items to storage
  Future<void> saveAnalysis() async {
    if (_currentAnalysis != null) {
      await _storageService.saveColorAnalysis(_currentAnalysis!);
      await _loadSavedAnalyses();
    }
  }
  
  Future<void> savePalette() async {
    if (_currentPalette != null) {
      await _storageService.saveColorPalette(_currentPalette!);
      await _loadSavedPalettes();
    }
  }
  
  Future<void> saveMeaning() async {
    if (_currentMeaning != null) {
      await _storageService.saveColorMeaning(_currentMeaning!);
      await _loadSavedMeanings();
    }
  }
  
  // Delete items from storage
  Future<void> deleteAnalysis(String id) async {
    await _storageService.deleteColorAnalysis(id);
    await _loadSavedAnalyses();
  }
  
  Future<void> deletePalette(String id) async {
    await _storageService.deleteColorPalette(id);
    await _loadSavedPalettes();
  }
  
  Future<void> deleteMeaning(String id) async {
    await _storageService.deleteColorMeaning(id);
    await _loadSavedMeanings();
  }

  // Clear saved data (useful for structure updates)
  Future<void> clearAllSavedData() async {
    await _storageService.clearAllData();
    _savedAnalyses.clear();
    _savedPalettes.clear();
    _savedMeanings.clear();
    notifyListeners();
  }

  Future<void> clearSavedAnalyses() async {
    await _storageService.clearAllColorAnalyses();
    _savedAnalyses.clear();
    notifyListeners();
  }
  
  // Helper methods
  void _setLoading() {
    _status = AnalysisStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }
  
  void _setError(String message) {
    _status = AnalysisStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
  
  // Load saved items from storage
  Future<void> _loadSavedItems() async {
    await _loadSavedAnalyses();
    await _loadSavedPalettes();
    await _loadSavedMeanings();
  }
  
  Future<void> _loadSavedAnalyses() async {
    _savedAnalyses = _storageService.getAllColorAnalyses();
    notifyListeners();
  }
  
  Future<void> _loadSavedPalettes() async {
    _savedPalettes = await _storageService.getAllColorPalettes();
    notifyListeners();
  }
  
  Future<void> _loadSavedMeanings() async {
    _savedMeanings = await _storageService.getAllColorMeanings();
    notifyListeners();
  }
  
  // Reset current items
  void resetCurrentAnalysis() {
    _currentAnalysis = null;
    _status = AnalysisStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
  
  void resetCurrentPalette() {
    _currentPalette = null;
    _status = AnalysisStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
  
  void resetCurrentMeaning() {
    _currentMeaning = null;
    _status = AnalysisStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
  
  // Helper to reset state and prepare for a new input
  void resetForNewInput() {
    _status = AnalysisStatus.idle;
    _errorMessage = null;
    _currentAnalysis = null;
    _currentPalette = null;
    _currentMeaning = null;
    notifyListeners();
  }
}
