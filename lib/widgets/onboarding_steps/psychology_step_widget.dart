import 'package:flutter/material.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class PsychologyStepWidget extends StatelessWidget {
  final OnboardingStep stepData;
  final Gradient sectionGradient;
  final IconData iconData;
  // Placeholder image, update as needed
  final String imagePath = 'assets/images/girl5.jpg'; // Or use one of the girl images e.g. girl1.jpg

  const PsychologyStepWidget({
    Key? key,
    required this.stepData,
    required this.sectionGradient,
    required this.iconData,
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
        // Dark overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                  Colors.black.withOpacity(0.55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Original content from _buildPsychologyStep, adapted
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: sectionGradient, // Use passed gradient
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: sectionGradient.colors.first.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 7),
                    ),
                  ]
                ),
                child: Icon(
                  iconData, // Use passed icon data
                  size: 40,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 24),
              
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
                      color: Colors.white.withOpacity(0.9), // Adjusted for contrast
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
              
              // Benefits in a clean list card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85), // Semi-transparent card
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                            color: sectionGradient.colors.first, // Use gradient color for bullet
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            benefit,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor.withOpacity(0.95), // Darker text on light card
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
        ),
      ],
    );
  }
}
