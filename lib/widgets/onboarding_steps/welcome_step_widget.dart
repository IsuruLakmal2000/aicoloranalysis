import 'package:flutter/material.dart';
import '../../providers/onboarding_provider.dart';

class WelcomeStepWidget extends StatelessWidget {
  final OnboardingStep stepData;
  final Gradient backgroundGradient;
  final IconData iconData;

  const WelcomeStepWidget({
    Key? key,
    required this.stepData,
    required this.backgroundGradient,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/girl2.png', // Using the existing image path
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
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),
        // Content
        Padding(
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
                  gradient: backgroundGradient, // Use passed gradient
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: backgroundGradient.colors.first.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  iconData, // Use passed icon data
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Title
              Text(
                stepData.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                stepData.subtitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                       shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Description
              Text(
                stepData.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                       shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              
              const Spacer(flex: 3),
            ],
          ),
        ),
      ],
    );
  }
}
