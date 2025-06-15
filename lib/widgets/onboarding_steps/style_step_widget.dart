
import 'package:flutter/material.dart';
import '../../providers/onboarding_provider.dart';

class StyleStepWidget extends StatelessWidget {
  final OnboardingStep stepData;
  final Gradient sectionGradient;
  final IconData iconData;

  const StyleStepWidget({
    Key? key,
    required this.stepData,
    required this.sectionGradient,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/girl1.jpg', // Using girl1.jpg for style step
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.4),
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
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: sectionGradient,
                  borderRadius: BorderRadius.circular(24),
                   boxShadow: [
                    BoxShadow(
                      color: sectionGradient.colors.first.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  iconData, // Use passed iconData
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                stepData.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white, // Adjusted for contrast
                      fontWeight: FontWeight.w700,
                       shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                stepData.subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.85), // Adjusted for contrast
                      fontWeight: FontWeight.w500,
                       shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
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
                      sectionGradient,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStyleCategory(
                      context,
                      Icons.face,
                      'Makeup',
                      'Perfect shades',
                      sectionGradient,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStyleCategory(
                      context,
                      Icons.home,
                      'Home',
                      'Decor colors',
                      sectionGradient,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                stepData.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8), // Adjusted for contrast
                      height: 1.4,
                       shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.2),
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

  Widget _buildStyleCategory(BuildContext context, IconData icon, String title, String subtitle, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Semi-transparent card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
              color: gradient.colors.first.withOpacity(0.2), // Use gradient color
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: gradient.colors.first, // Use gradient color
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white, // Adjusted for contrast
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.7), // Adjusted for contrast
                  fontSize: 10,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
