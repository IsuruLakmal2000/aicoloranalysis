import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'color_analysis_screen.dart';
import 'palette_generator_screen.dart';
import 'color_psychology_screen.dart';
import 'collection_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  final int initialIndex;
  
  // Tab indices for easy access
  static const int homeTab = 0;
  static const int analysisTab = 1;
  static const int paletteTab = 2;
  static const int psychologyTab = 3;
  static const int collectionTab = 4;
  
  // Static method to navigate to a specific tab
  static void navigateTo(BuildContext context, int tabIndex) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationScreen(initialIndex: tabIndex),
      ),
      (route) => false,
    );
  }

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void navigateToTab(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const ColorAnalysisScreen(),
    const PaletteGeneratorScreen(),
    const ColorPsychologyScreen(),
    const CollectionScreen(),
  ];
  
  Widget _buildIcon(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 3,
          width: 24,
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.deepMauve : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Icon(
          icon,
          size: isSelected ? 28 : 24,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.deepMauve,
            unselectedItemColor: AppTheme.textSecondaryColor.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.home, 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.person, 1),
                label: 'Analysis',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.palette, 2),
                label: 'Palette',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.psychology, 3),
                label: 'Psychology',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.favorite, 4),
                label: 'Collection',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
