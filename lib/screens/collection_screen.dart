import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/color_analysis.dart';
import '../models/color_meaning.dart';
import '../models/color_palette.dart';
import '../providers/color_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/soft_button.dart';
import '../widgets/soft_card.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Collection',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppTheme.textPrimaryColor,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.textPrimaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'ANALYSES'),
            Tab(text: 'PALETTES'),
            Tab(text: 'MEANINGS'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAnalysesTab(),
            _buildPalettesTab(),
            _buildMeaningsTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalysesTab() {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        final analyses = colorProvider.savedAnalyses;
        
        if (analyses.isEmpty) {
          return _buildEmptyState(
            'No saved color analyses', 
            'Analyze your personal color type to save analyses here',
            Icons.person,
            AppTheme.primaryColor,
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: analyses.length,
          itemBuilder: (context, index) {
            final analysis = analyses[index];
            return _buildAnalysisCard(context, analysis);
          },
        );
      },
    );
  }
  
  Widget _buildPalettesTab() {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        final palettes = colorProvider.savedPalettes;
        
        if (palettes.isEmpty) {
          return _buildEmptyState(
            'No saved palettes', 
            'Generate color palettes from images to save them here',
            Icons.palette,
            AppTheme.secondaryColor,
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: palettes.length,
          itemBuilder: (context, index) {
            final palette = palettes[index];
            return _buildPaletteCard(context, palette);
          },
        );
      },
    );
  }
  
  Widget _buildMeaningsTab() {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        final meanings = colorProvider.savedMeanings;
        
        if (meanings.isEmpty) {
          return _buildEmptyState(
            'No saved color meanings', 
            'Explore color psychology to save meanings here',
            Icons.psychology,
            AppTheme.accentColor,
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: meanings.length,
          itemBuilder: (context, index) {
            final meaning = meanings[index];
            return _buildMeaningCard(context, meaning);
          },
        );
      },
    );
  }
  
  Widget _buildEmptyState(String title, String message, IconData icon, Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon,
                size: 40,
                color: color,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalysisCard(BuildContext context, ColorAnalysis analysis) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SoftCard(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    analysis.seasonType,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _confirmDelete(
                        context, 
                        'Delete Analysis', 
                        'Are you sure you want to delete this color analysis?',
                        () => Provider.of<ColorProvider>(context, listen: false).deleteAnalysis(analysis.id),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                analysis.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Text(
                'Color Palette',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: analysis.primaryColors.length,
                  itemBuilder: (context, index) {
                    final colorHex = analysis.primaryColors[index];
                    final color = _hexToColor(colorHex);
                    return Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Saved on ${_formatDate(analysis.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPaletteCard(BuildContext context, ColorPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SoftCard(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    palette.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _confirmDelete(
                        context, 
                        'Delete Palette', 
                        'Are you sure you want to delete this color palette?',
                        () => Provider.of<ColorProvider>(context, listen: false).deletePalette(palette.id),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                palette.description ?? 'No description available',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: palette.colors.map((colorHex) {
                      final color = _hexToColor(colorHex);
                      return Expanded(
                        child: Container(
                          color: color,
                          height: 60,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Mood: ${palette.mood ?? 'Not specified'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Saved on ${_formatDate(palette.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMeaningCard(BuildContext context, ColorMeaning meaning) {
    final color = _hexToColor(meaning.colorHex);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SoftCard(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      meaning.colorName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _confirmDelete(
                        context, 
                        'Delete Color Meaning', 
                        'Are you sure you want to delete this color meaning?',
                        () => Provider.of<ColorProvider>(context, listen: false).deleteMeaning(meaning.id),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                meaning.shortDescription,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Text(
                'Saved on ${_formatDate(meaning.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _confirmDelete(
    BuildContext context,
    String title,
    String message,
    VoidCallback onDelete,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
