import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/soft_card.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Text(
                  'Welcome to',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'AuraColor',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover your personal colors and create beautiful palettes',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                
                const SizedBox(height: 30),
                
                // Personal Color Analysis intro section
                SoftCard(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.person,
                                color: AppTheme.primaryColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Personal Color Analysis',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppTheme.textPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Find your perfect color palette based on your natural features',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Personal color analysis helps you discover which colors complement your natural features. By understanding your color season, you can make confident choices in fashion, makeup, and accessories.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // What you'll discover section
                        Text(
                          'What you\'ll discover:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildBenefitItem(
                          context,
                          icon: Icons.style,
                          text: 'Your seasonal color palette (Spring, Summer, Autumn, or Winter)',
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          context,
                          icon: Icons.color_lens,
                          text: 'Perfect clothing colors for your complexion',
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          context,
                          icon: Icons.face,
                          text: 'Makeup recommendations tailored to your features',
                        ),
                        const SizedBox(height: 12),
                        _buildBenefitItem(
                          context,
                          icon: Icons.shopping_bag,
                          text: 'Styling tips to enhance your natural beauty',
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Get started button
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the Analysis tab using our static method
                            MainNavigationScreen.navigateTo(context, MainNavigationScreen.analysisTab);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 3,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Start Your Color Analysis',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // How it works section
                Text(
                  'How it works',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                
                _buildStepCard(
                  context,
                  number: "1",
                  title: "Take a selfie",
                  description: "Upload a well-lit photo of yourself without makeup in natural daylight",
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 16),
                
                _buildStepCard(
                  context, 
                  number: "2",
                  title: "AI analysis", 
                  description: "Our AI analyzes your skin tone, hair color, and facial features",
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(height: 16),
                
                _buildStepCard(
                  context,
                  number: "3",
                  title: "Get your results",
                  description: "Receive your personalized color season and recommendations",
                  color: AppTheme.accentColor,
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // No need for the _buildFeatureCard method as we're not using it anymore
  
  Widget _buildBenefitItem(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(BuildContext context, {required String number, required String title, required String description, required Color color}) {
    return SoftCard(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
