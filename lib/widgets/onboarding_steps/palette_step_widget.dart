import 'package:flutter/material.dart';
import '../../providers/onboarding_provider.dart';
import '../../theme/app_theme.dart';

class PaletteStepWidget extends StatelessWidget {
  final OnboardingStep stepData;
  final Gradient sectionGradient;
  // Using one of the available girl images, or a placeholder
  final String imagePath = 'assets/images/girl1.jpg'; // Update if you have a more specific image

  const PaletteStepWidget({
    Key? key,
    required this.stepData,
    required this.sectionGradient,
  }) : super(key: key);

  // Helper to build color boxes, moved from the original _buildPaletteStep
  Widget _buildColorBox(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

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
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Original content from _buildPaletteStep, adapted
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Title and subtitle
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
              
              // Color palette mockup card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Semi-transparent white card
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
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
                        color: AppTheme.backgroundColor.withOpacity(0.8), // Slightly transparent background
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200.withOpacity(0.7)),
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
                      color: sectionGradient.colors.first, // Use gradient color for icon
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to copy any color',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              Text(
                stepData.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.85), // Adjusted for contrast
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
                maxLines: 2,
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
