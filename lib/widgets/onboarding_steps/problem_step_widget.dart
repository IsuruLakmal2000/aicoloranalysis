import 'package:flutter/material.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class ProblemStepWidget extends StatelessWidget {
  final OnboardingStep stepData;
  final Gradient sectionGradient;
  // Using an existing image from your assets folder
  final String imagePath = 'assets/images/girl1.jpg'; // Updated to use existing image

  const ProblemStepWidget({
    Key? key,
    required this.stepData,
    required this.sectionGradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            imagePath, 
            fit: BoxFit.cover,
          ),
        ),
        // Dark overlay for better text readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65), // Slightly more opacity for potentially busier images
                  Colors.black.withOpacity(0.35),
                  Colors.transparent,
                  Colors.black.withOpacity(0.55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.55, 1.0], // Adjusted stops for a balanced overlay
              ),
            ),
          ),
        ),
        // Original content from _buildProblemStep, adapted
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Title
              Text(
                stepData.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white, // Adjusted for contrast
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          blurRadius: 7.0,
                          color: Colors.black.withOpacity(0.35),
                          offset: const Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                stepData.subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9), // Use white for subtitle too for consistency on image
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Before/After visual - After container larger for emphasis
              Row(
                children: [
                  Expanded(
                    flex: 2, // Smaller flex for Before container
                    child: Container(
                      height: 160, // Smaller height for Before
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade100.withOpacity(0.8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sentiment_dissatisfied, 
                               color: Colors.red.shade400, size: 28),
                          const SizedBox(height: 10),
                          Text(
                            'Before',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Guessing colors\nWasted money\nLack confidence',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red.shade600,
                              height: 1.2,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3, // Larger flex for After container
                    child: Container(
                      height: 200, // Larger height for After
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            sectionGradient.colors.first.withOpacity(0.9),
                            sectionGradient.colors.last.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: sectionGradient.colors.first.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sentiment_very_satisfied, 
                               color: sectionGradient.colors.first.computeLuminance() > 0.5 
                                      ? AppTheme.textPrimaryColor.withOpacity(0.8) 
                                      : Colors.white.withOpacity(0.9),
                               size: 36),
                          const SizedBox(height: 14),
                          Text(
                            'After',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: sectionGradient.colors.first.computeLuminance() > 0.5 
                                     ? AppTheme.textPrimaryColor 
                                     : Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Perfect colors\nSmart shopping\nFeel amazing',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: sectionGradient.colors.first.computeLuminance() > 0.5 
                                     ? AppTheme.textSecondaryColor 
                                     : Colors.white.withOpacity(0.9),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
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
                      color: Colors.white.withOpacity(1), // Adjusted for contrast
                      height: 1.4,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
