import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/onboarding_steps/welcome_step_widget.dart';
import '../widgets/onboarding_steps/problem_step_widget.dart';
import '../widgets/onboarding_steps/analysis_step_widget.dart';
import '../widgets/onboarding_steps/palette_step_widget.dart';
import '../widgets/onboarding_steps/psychology_step_widget.dart';
import '../widgets/onboarding_steps/style_step_widget.dart';
import '../widgets/onboarding_steps/final_step_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize confetti controller
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingProvider>(
      builder: (context, onboardingProvider, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Full screen PageView for background images
              PageView.builder(
                controller: _pageController,
                itemCount: onboardingProvider.totalSteps,
                onPageChanged: (index) {
                  onboardingProvider.setCurrentStep(index);
                  // Start confetti animation when reaching the final page
                  if (index == onboardingProvider.totalSteps - 1) {
                    _confettiController.play();
                  } else {
                    _confettiController.stop();
                  }
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingContent(
                      context, onboardingProvider, index);
                },
              ),
              // Bottom navigation positioned on top of the background
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNavigation(context, onboardingProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOnboardingContent(
      BuildContext context, OnboardingProvider provider, int index) {
    final stepData = provider.getStepData(index);
    final gradient = _getGradientForStep(index);
    final icon = _getIconForStep(index);

    // Different layout for each step
    switch (index) {
      case 0:
        return WelcomeStepWidget(stepData: stepData, backgroundGradient: gradient, iconData: icon);
      case 1:
        return ProblemStepWidget(stepData: stepData, sectionGradient: gradient);
      case 2:
        return AnalysisStepWidget(stepData: stepData, sectionGradient: gradient, iconData: icon);
      case 3:
        return PaletteStepWidget(stepData: stepData, sectionGradient: gradient);
      case 4:
        return PsychologyStepWidget(stepData: stepData, sectionGradient: gradient, iconData: icon);
      case 5:
        return StyleStepWidget(stepData: stepData, sectionGradient: gradient, iconData: icon);
      case 6:
        return FinalStepWidget(stepData: stepData, sectionGradient: gradient, iconData: icon, confettiController: _confettiController);
      default:
        return WelcomeStepWidget(stepData: stepData, backgroundGradient: gradient, iconData: icon); // Default to welcome
    }
  }

  // Helper to get gradient for each step
  Gradient _getGradientForStep(int index) {
    List<Gradient> gradients = [
      LinearGradient(colors: [AppTheme.primaryColor, AppTheme.secondaryColor]), // Welcome
      LinearGradient(colors: [AppTheme.strongMauve, AppTheme.accentColor]), // Problem
      LinearGradient(colors: [AppTheme.accentColor, AppTheme.softPurple]), // Analysis
      LinearGradient(colors: [AppTheme.softPurple, AppTheme.primaryColor]), // Palette
      LinearGradient(colors: [AppTheme.primaryColor, AppTheme.secondaryColor]), // Psychology (reusing)
      LinearGradient(colors: [AppTheme.strongMauve, AppTheme.accentColor]), // Style (reusing)
      LinearGradient(colors: [AppTheme.accentColor, AppTheme.softPurple]), // Final (reusing)
    ];
    return gradients[index % gradients.length];
  }

  // Helper to get icon for each step
  IconData _getIconForStep(int index) {
    List<IconData> icons = [
      Icons.handshake, // Welcome
      Icons.help_outline, // Problem
      Icons.science, // Analysis
      Icons.palette, // Palette
      Icons.psychology, // Psychology
      Icons.style, // Style
      Icons.celebration, // Final
    ];
    return icons[index % icons.length];
  }

  Widget _buildBottomNavigation(BuildContext context, OnboardingProvider provider) {
    bool isLastStep = provider.currentStep == provider.totalSteps - 1;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15 + bottomPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0 + bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (provider.currentStep > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              child: Text(
                provider.currentStep > 0 ? 'Back' : 'Skip',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(provider.totalSteps, (i) { // Changed index to i to avoid conflict
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: provider.currentStep == i ? 12.0 : 8.0,
                  height: provider.currentStep == i ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    gradient: provider.currentStep == i
                        ? _getGradientForStep(i)
                        : null,
                    color: provider.currentStep == i
                        ? null
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: provider.currentStep == i ? [
                      BoxShadow(
                        color: _getGradientForStep(i).colors.first.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0,2)
                      )
                    ] : [],
                  ),
                );
              }),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getGradientForStep(provider.currentStep).colors.first,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 5,
                shadowColor: _getGradientForStep(provider.currentStep).colors.first.withOpacity(0.5),
              ),
              onPressed: () {
                if (isLastStep) {
                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Text(
                isLastStep ? 'Get Started' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
