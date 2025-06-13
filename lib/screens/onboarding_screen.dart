import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import '../providers/onboarding_provider.dart';
import '../theme/app_theme.dart';

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
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
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
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
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
                      return _buildOnboardingContent(context, onboardingProvider, index);
                    },
                  ),
                ),
                _buildBottomNavigation(context, onboardingProvider),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildOnboardingContent(BuildContext context, OnboardingProvider provider, int index) {
    final stepData = provider.getStepData(index);
    
    // Different layout for each step
    switch (index) {
      case 0:
        return _buildWelcomeStep(context, stepData, index);
      case 1:
        return _buildProblemStep(context, stepData, index);
      case 2:
        return _buildAnalysisStep(context, stepData, index);
      case 3:
        return _buildPaletteStep(context, stepData, index);
      case 4:
        return _buildPsychologyStep(context, stepData, index);
      case 5:
        return _buildStyleStep(context, stepData, index);
      case 6:
        return _buildFinalStep(context, stepData, index);
      default:
        return _buildWelcomeStep(context, stepData, index);
    }
  }

  // Step 1: Welcome - Center focused with large icon
  Widget _buildWelcomeStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          
          // Large central icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: _getGradientForStep(index),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getGradientForStep(index).colors.first.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Icon(
              _getIconForStep(index),
              size: 60,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            stepData.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            stepData.subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _getGradientForStep(index).colors.first,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Description
          Text(
            stepData.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
          
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  // Step 2: Problem - Visual problem/solution comparison
  Widget _buildProblemStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Spacer(),
          
          // Title
          Text(
            stepData.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            stepData.subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getGradientForStep(index).colors.first,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Before/After visual
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.sentiment_dissatisfied, 
                           color: Colors.red.shade400, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'Before',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Guessing colors\nWasted money\nLack confidence',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red.shade600,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getGradientForStep(index).colors.first.withOpacity(0.1),
                        _getGradientForStep(index).colors.last.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.sentiment_very_satisfied, 
                           color: _getGradientForStep(index).colors.first, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'After',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: _getGradientForStep(index).colors.first,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Perfect colors\nSmart shopping\nFeel amazing',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getGradientForStep(index).colors.first,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text(
            stepData.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  // Step 3: Analysis - Side-by-side layout with problem/solution
  Widget _buildAnalysisStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Spacer(),
          
          // Icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: _getGradientForStep(index),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getIconForStep(index),
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stepData.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      stepData.subtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _getGradientForStep(index).colors.first,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Problem section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Column(
              children: [
                Icon(Icons.help_outline, color: Colors.red.shade400, size: 24),
                const SizedBox(height: 12),
                Text(
                  stepData.painPoint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Solution section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getGradientForStep(index).colors.first.withOpacity(0.1),
                  _getGradientForStep(index).colors.last.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: _getGradientForStep(index).colors.first,
                  size: 24,
                ),
                const SizedBox(height: 12),
                Text(
                  stepData.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  // Step 3: Palette - Visual grid layout
  Widget _buildPaletteStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Spacer(),
          
          // Title and subtitle
          Text(
            stepData.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            stepData.subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getGradientForStep(index).colors.first,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Color palette mockup
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Phone mockup with color grid
                Container(
                  width: 200,
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildColorBox(const Color(0xFF8B5CF6)),
                      _buildColorBox(const Color(0xFFEC4899)),
                      _buildColorBox(const Color(0xFF06B6D4)),
                      _buildColorBox(const Color(0xFFF59E0B)),
                      _buildColorBox(const Color(0xFF10B981)),
                      _buildColorBox(const Color(0xFFEF4444)),
                      _buildColorBox(const Color(0xFF6366F1)),
                      _buildColorBox(const Color(0xFF84CC16)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Icon(
                  Icons.copy_outlined,
                  color: _getGradientForStep(index).colors.first,
                  size: 20,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to copy any color',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            stepData.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  // Step 4: Psychology - Card-based layout
  Widget _buildPsychologyStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Spacer(),
          
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: _getGradientForStep(index),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              _getIconForStep(index),
              size: 40,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            stepData.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            stepData.subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getGradientForStep(index).colors.first,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Benefits in a clean list
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: stepData.benefits.take(3).map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _getGradientForStep(index).colors.first,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        benefit,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  // Step 6: Style - Styling recommendations
  Widget _buildStyleStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          const Spacer(),
          
          // Icon and title
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: _getGradientForStep(index),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.style,
              size: 40,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            stepData.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            stepData.subtitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getGradientForStep(index).colors.first,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Style categories
          Row(
            children: [
              Expanded(
                child: _buildStyleCategory(
                  context,
                  Icons.checkroom,
                  'Wardrobe',
                  'Seasonal colors',
                  index,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStyleCategory(
                  context,
                  Icons.face,
                  'Makeup',
                  'Perfect shades',
                  index,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStyleCategory(
                  context,
                  Icons.home,
                  'Home',
                  'Decor colors',
                  index,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text(
            stepData.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildStyleCategory(BuildContext context, IconData icon, String title, String subtitle, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getGradientForStep(index).colors.first.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: _getGradientForStep(index).colors.first,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Step 7: Final - Call to action with confetti
  Widget _buildFinalStep(BuildContext context, OnboardingStep stepData, int index) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Central celebration icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: _getGradientForStep(index),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getGradientForStep(index).colors.first.withOpacity(0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Final message
              Text(
                stepData.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                stepData.subtitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _getGradientForStep(index).colors.first,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                stepData.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              
              const SizedBox(height: 40),
              
              // Ready indicator with users count
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradientForStep(index).colors.map((c) => c.withOpacity(0.1)).toList(),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: _getGradientForStep(index).colors.first,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '10,000+ users transformed',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _getGradientForStep(index).colors.first,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) => 
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '4.9 star average rating',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
            ],
          ),
          
          // Confetti widget positioned at the top center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFFF6B9D),
                Color(0xFFFFD93D),
                Color(0xFF6BCF7F),
                Color(0xFF4ECDC4),
                Color(0xFFA8E6CF),
                Color(0xFFFFB6C1),
                Color(0xFFDDA0DD),
                Color(0xFFF0E68C),
                Color(0xFFFF9999),
                Color(0xFF87CEEB),
              ],
              createParticlePath: _drawStar,
              numberOfParticles: 30,
              gravity: 0.1,
              emissionFrequency: 0.02,
              minBlastForce: 5,
              maxBlastForce: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Star path for confetti particles
  Path _drawStar(Size size) {
    // Create a star shape path
    double width = size.width;
    double height = size.height;
    
    final Path path = Path();
    path.moveTo(width * 0.5, 0);
    path.lineTo(width * 0.618, height * 0.345);
    path.lineTo(width, height * 0.345);
    path.lineTo(width * 0.691, height * 0.655);
    path.lineTo(width * 0.809, height);
    path.lineTo(width * 0.5, height * 0.764);
    path.lineTo(width * 0.191, height);
    path.lineTo(width * 0.309, height * 0.655);
    path.lineTo(0, height * 0.345);
    path.lineTo(width * 0.382, height * 0.345);
    path.close();
    
    return path;
  }

  // New minimalistic bottom navigation
  // New minimalistic bottom navigation
  Widget _buildBottomNavigation(BuildContext context, OnboardingProvider provider) {
    final isLastStep = provider.currentStep == provider.totalSteps - 1;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Minimalistic progress dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                provider.totalSteps,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: index == provider.currentStep ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: index == provider.currentStep
                        ? _getGradientForStep(provider.currentStep).colors.first
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Single action button
            if (isLastStep)
              // Final CTA button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: _getGradientForStep(provider.currentStep),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _getGradientForStep(provider.currentStep).colors.first.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: provider.completeOnboarding,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.rocket_launch,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Start My Color Journey',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              // Regular navigation
              Row(
                children: [
                  // Skip button
                  TextButton(
                    onPressed: provider.completeOnboarding,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Next button as floating action
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _getGradientForStep(provider.currentStep),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getGradientForStep(provider.currentStep).colors.first.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
  
  IconData _getIconForStep(int step) {
    switch (step) {
      case 0:
        return Icons.auto_awesome;
      case 1:
        return Icons.trending_up;
      case 2:
        return Icons.face_retouching_natural;
      case 3:
        return Icons.palette;
      case 4:
        return Icons.psychology_alt;
      case 5:
        return Icons.style;
      case 6:
        return Icons.celebration;
      default:
        return Icons.auto_awesome;
    }
  }
  
  LinearGradient _getGradientForStep(int step) {
    switch (step) {
      case 0:
        return LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 1:
        return LinearGradient(
          colors: [AppTheme.strongMauve, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.softPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [AppTheme.softPurple, AppTheme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 4:
        return LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.strongMauve],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 5:
        return LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 6:
        return LinearGradient(
          colors: [AppTheme.strongMauve, AppTheme.primaryColor, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Widget _buildColorBox(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
