import 'package:flutter/material.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class AnalysisStepWidget extends StatelessWidget {
  final OnboardingStep stepData;
  final Gradient sectionGradient;
  final IconData iconData;
  // Using one of the available girl images
  final String imagePath = 'assets/images/girl3.jpg'; 

  const AnalysisStepWidget({
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
        // Dark overlay for better text readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7), // Darker overlay for this step
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Original content from _buildAnalysisStep, adapted
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Icon and title section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: sectionGradient, // Use passed gradient
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: sectionGradient.colors.first.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    ),
                    child: Icon(
                      iconData, // Use passed icon data
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
                                color: Colors.white, // Adjusted for contrast
                                fontWeight: FontWeight.w700,
                                shadows: [
                                  Shadow(
                                    blurRadius: 7.0,
                                    color: Colors.black.withOpacity(0.4),
                                    offset: const Offset(1.5, 1.5),
                                  ),
                                ],
                              ),
                        ),
                        Text(
                          stepData.subtitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9), // Adjusted for contrast
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Problem section card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50.withOpacity(0.85), // Semi-transparent card
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade100.withOpacity(0.7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
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
              
              // Solution section card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient( // Using the section gradient for the solution card
                    colors: [
                      sectionGradient.colors.first.withOpacity(0.8),
                      sectionGradient.colors.last.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: sectionGradient.colors.first.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: sectionGradient.colors.first.computeLuminance() > 0.5 
                             ? AppTheme.textPrimaryColor.withOpacity(0.85) 
                             : Colors.white.withOpacity(0.9), // Icon color contrast
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      stepData.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: sectionGradient.colors.first.computeLuminance() > 0.5 
                               ? AppTheme.textSecondaryColor.withOpacity(0.9) 
                               : Colors.white.withOpacity(0.85), // Text color contrast
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
        ),
      ],
    );
  }
}
