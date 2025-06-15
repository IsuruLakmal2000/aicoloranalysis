
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math'; // For Random

import '../../providers/onboarding_provider.dart';

class FinalStepWidget extends StatefulWidget {
  final OnboardingStep stepData;
  final Gradient sectionGradient;
  final IconData iconData;
  final ConfettiController confettiController;

  const FinalStepWidget({
    Key? key,
    required this.stepData,
    required this.sectionGradient,
    required this.iconData,
    required this.confettiController,
  }) : super(key: key);

  @override
  _FinalStepWidgetState createState() => _FinalStepWidgetState();
}

class _FinalStepWidgetState extends State<FinalStepWidget> {

  Path _drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/girl2.png', // Placeholder for final step
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: widget.sectionGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.sectionGradient.colors.first.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Icon(
                  widget.iconData, // Use passed iconData
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                widget.stepData.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white, // Adjusted for contrast
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
              Text(
                widget.stepData.subtitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: widget.sectionGradient.colors.first.withOpacity(0.9), // Adjusted for contrast
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
              Text(
                widget.stepData.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.8), // Adjusted for contrast
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
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), // Semi-transparent card
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2))
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          color: widget.sectionGradient.colors.first.withOpacity(0.9),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '10,000+ users transformed',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white, // Adjusted for contrast
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) => 
                        Icon(
                          Icons.star,
                          color: Colors.amber.withOpacity(0.85),
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '4.9 star average rating',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.7), // Adjusted for contrast
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: widget.confettiController,
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
    );
  }
}
