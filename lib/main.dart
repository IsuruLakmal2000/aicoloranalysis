import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/color_analysis.dart';
import 'models/color_meaning.dart';
import 'models/color_palette.dart';
import 'providers/color_provider.dart';
import 'providers/onboarding_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/gemini_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file
  await dotenv.load();
  
  // Initialize Hive for web and mobile differently
  if (kIsWeb) {
    // For web, use the default path
    await Hive.initFlutter();
  } else {
    // For mobile, use the app documents directory
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
  }
  
  // Register Hive adapters (check if not already registered)
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ColorAnalysisAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ColorPaletteAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ColorMeaningAdapter());
  }
  
  // Open Hive boxes
  await Hive.openBox<ColorAnalysis>('color_analyses');
  await Hive.openBox<ColorPalette>('color_palettes');
  await Hive.openBox<ColorMeaning>('color_meanings');
  await Hive.openBox<bool>('app_settings');
  
  // Set preferred orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        Provider(create: (_) => GeminiService()),
        Provider(create: (_) => StorageService()),
        ChangeNotifierProxyProvider2<GeminiService, StorageService, ColorProvider>(
          create: (context) => ColorProvider(
            geminiService: context.read<GeminiService>(), 
            storageService: context.read<StorageService>(),
          ),
          update: (context, geminiService, storageService, previousProvider) => 
            previousProvider ?? ColorProvider(
              geminiService: geminiService, 
              storageService: storageService,
            ),
        ),
      ],
      child: Consumer<OnboardingProvider>(
        builder: (context, onboardingProvider, _) {
          return MaterialApp(
            title: 'AuraColor',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeData(),
            home: onboardingProvider.onboardingComplete
                ? const MainNavigationScreen()
                : const OnboardingScreen(),
            routes: {
              '/home': (context) => const MainNavigationScreen(initialIndex: MainNavigationScreen.homeTab),
              '/color-analysis': (context) => const MainNavigationScreen(initialIndex: MainNavigationScreen.analysisTab),
              '/palette-generator': (context) => const MainNavigationScreen(initialIndex: MainNavigationScreen.paletteTab),
              '/color-psychology': (context) => const MainNavigationScreen(initialIndex: MainNavigationScreen.psychologyTab),
              '/collection': (context) => const MainNavigationScreen(initialIndex: MainNavigationScreen.collectionTab),
            },
          );
        },
      ),
    );
  }
}
