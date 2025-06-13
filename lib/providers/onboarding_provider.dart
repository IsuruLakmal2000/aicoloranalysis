import 'package:flutter/material.dart';

class OnboardingStep {
  final String title;
  final String subtitle;
  final String description;
  final List<String> benefits;
  final String painPoint;

  OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.benefits,
    required this.painPoint,
  });
}

class OnboardingProvider extends ChangeNotifier {
  bool _onboardingComplete = false;
  int _currentStep = 0;
  
  // Enhanced onboarding content with pain points and benefits
  final List<OnboardingStep> _onboardingSteps = [
    OnboardingStep(
      title: 'Welcome to AuraColor',
      subtitle: 'Your Personal Style Revolution',
      description: 'Discover the science behind colors that make you shine. Transform your wardrobe with AI-powered color analysis.',
      benefits: [
        'Professional color analysis in seconds',
        'Personalized recommendations just for you',
        'Never waste money on wrong colors again'
      ],
      painPoint: 'Ready to discover your most flattering colors?',
    ),
    OnboardingStep(
      title: 'The Problem We Solve',
      subtitle: 'Stop Guessing, Start Glowing',
      description: 'Most people wear colors that wash them out, making them look tired and less confident.',
      benefits: [
        'Avoid unflattering color choices',
        'Look more vibrant and youthful',
        'Save time and money shopping'
      ],
      painPoint: 'Do you ever feel like nothing in your wardrobe makes you look your best?',
    ),
    OnboardingStep(
      title: 'AI-Powered Analysis',
      subtitle: 'Science Meets Beauty',
      description: 'Our advanced AI analyzes your unique skin tone, hair color, and eye color to determine your perfect seasonal palette.',
      benefits: [
        'Professional-grade color analysis',
        'Results backed by color science',
        'Instant personalized recommendations'
      ],
      painPoint: 'Professional consultations cost hundreds of dollars and require appointments.',
    ),
    OnboardingStep(
      title: 'Your Perfect Palette',
      subtitle: 'Colors That Love You Back',
      description: 'Get your personalized color palette with exact hex codes. Copy colors instantly for shopping and styling.',
      benefits: [
        'Take your colors shopping with you',
        'Match makeup and accessories perfectly',
        'Create cohesive looks effortlessly'
      ],
      painPoint: 'How many times have you bought something that looked great in store but terrible on you?',
    ),
    OnboardingStep(
      title: 'Color Psychology',
      subtitle: 'Colors That Speak Your Language',
      description: 'Understand how colors affect mood, confidence, and first impressions. Make powerful style choices.',
      benefits: [
        'Project confidence in every outfit',
        'Make memorable first impressions',
        'Express your personality through color'
      ],
      painPoint: 'Your clothes should make you feel powerful, not invisible.',
    ),
    OnboardingStep(
      title: 'Style Recommendations',
      subtitle: 'Curated Just for You',
      description: 'Get personalized styling tips, outfit ideas, and seasonal wardrobe recommendations based on your color type.',
      benefits: [
        'Seasonal wardrobe guidance',
        'Makeup color suggestions',
        'Home decor color ideas'
      ],
      painPoint: 'Struggling to put together outfits that work?',
    ),
    OnboardingStep(
      title: 'Join the Revolution',
      subtitle: 'Your Color Journey Starts Now',
      description: 'Join thousands who\'ve discovered their signature colors and transformed their style confidence.',
      benefits: [
        'Look 10 years younger instantly',
        'Receive compliments everywhere you go',
        'Feel confident in every photo'
      ],
      painPoint: 'Ready to unlock the secret to effortless style?',
    ),
  ];
  
  // Getters
  bool get onboardingComplete => _onboardingComplete;
  int get currentStep => _currentStep;
  int get totalSteps => _onboardingSteps.length;
  OnboardingStep get currentStepData => _onboardingSteps[_currentStep];
  String get currentTitle => _onboardingSteps[_currentStep].title;
  String get currentDescription => _onboardingSteps[_currentStep].description;
  
  OnboardingStep getStepData(int index) {
    if (index >= 0 && index < _onboardingSteps.length) {
      return _onboardingSteps[index];
    }
    return _onboardingSteps[0]; // fallback to first step
  }
  
  // Methods
  void setCurrentStep(int step) {
    if (step >= 0 && step < _onboardingSteps.length) {
      _currentStep = step;
      notifyListeners();
    }
  }
  
  void nextStep() {
    if (_currentStep < _onboardingSteps.length - 1) {
      _currentStep++;
      notifyListeners();
    } else {
      completeOnboarding();
    }
  }
  
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }
  
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }
  
  void resetOnboarding() {
    _onboardingComplete = false;
    _currentStep = 0;
    notifyListeners();
  }
}
