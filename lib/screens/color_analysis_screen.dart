import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/soft_button.dart';
import '../widgets/soft_card.dart';
import '../widgets/full_screen_color_preview.dart';

class ColorAnalysisScreen extends StatefulWidget {
  const ColorAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<ColorAnalysisScreen> createState() => _ColorAnalysisScreenState();
}

class _ColorAnalysisScreenState extends State<ColorAnalysisScreen>
    with TickerProviderStateMixin {
  Uint8List? _imageBytes;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    // Start the fade animation immediately for the upload section
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        final analysis = colorProvider.currentAnalysis;
        final isLoading = colorProvider.status == AnalysisStatus.loading;
        final hasError = colorProvider.status == AnalysisStatus.error;

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: CustomScrollView(
            slivers: [
              // Professional App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.backgroundColor,
                elevation: 0,
                automaticallyImplyLeading: false, // Remove back button
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Personal Color Analysis',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                ),
                actions: [
                  if (analysis != null)
                    Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        icon: Icon(
                          colorProvider.isCurrentAnalysisSaved 
                              ? Icons.favorite 
                              : Icons.favorite_border,
                          color: AppTheme.strongMauve,
                        ),
                        onPressed: () {
                          colorProvider.saveAnalysis();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Analysis saved to favorites'),
                              backgroundColor: AppTheme.strongMauve,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step indicator
                      _buildStepIndicator(analysis, isLoading),
                      const SizedBox(height: 32),

                      // Main content based on state
                      if (analysis == null && !isLoading && !hasError)
                        _buildUploadSection()
                      else if (isLoading)
                        _buildLoadingSection()
                      else if (hasError)
                        _buildErrorSection(colorProvider.errorMessage)
                      else if (analysis != null)
                        _buildResultsSection(analysis),

                      const SizedBox(height: 32),

                      // Action buttons
                      _buildActionButtons(analysis, isLoading, hasError, colorProvider),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Professional step indicator
  Widget _buildStepIndicator(dynamic analysis, bool isLoading) {
    int currentStep = 1; // Start with step 1 active (Upload step)
    if (_imageBytes != null) currentStep = 2; // Move to step 2 when image is selected
    if (isLoading) currentStep = 2; // Stay on step 2 during analysis
    if (analysis != null) currentStep = 3; // Move to step 3 when analysis is complete

    return SoftCard(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            _buildStepItem(1, 'Upload', currentStep >= 1),
            Expanded(child: _buildStepLine(currentStep >= 2)),
            _buildStepItem(2, 'Analyze', currentStep >= 2),
            Expanded(child: _buildStepLine(currentStep >= 3)),
            _buildStepItem(3, 'Results', currentStep >= 3),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.strongMauve : AppTheme.backgroundColor,
            border: Border.all(
              color: isActive ? AppTheme.strongMauve : AppTheme.textSecondaryColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.strongMauve : AppTheme.textSecondaryColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.strongMauve : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  // Upload section with elegant design
  Widget _buildUploadSection() {
    print('Building upload section'); // Debug log
    return Column(
      children: [
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SoftCard(
                backgroundColor: Colors.white,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Upload Your Photo',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Take a clear selfie in natural daylight for accurate color analysis. Your face should be clearly visible and well-lit.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Add helpful guidelines
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppTheme.strongMauve,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Face clearly visible and well-lit',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppTheme.strongMauve,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Natural daylight or good lighting',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppTheme.strongMauve,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'No sunglasses or face coverings',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (_imageBytes == null) // Only show buttons when no image is selected
                        Column(
                          children: [
                            SoftButton(
                              height: 60.0,
                              onPressed: () => _pickImageFromCamera(),
                              backgroundColor: AppTheme.strongMauve,
                              textColor: Colors.white,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, size: 24, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SoftButton(
                              height: 60.0,
                              onPressed: _pickImage,
                              backgroundColor: AppTheme.primaryColor,
                              textColor: AppTheme.textPrimaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_library_outlined, size: 24, color: AppTheme.textPrimaryColor),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Choose from Gallery',
                                    style: TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (_imageBytes != null) ...[
                        const SizedBox(height: 24),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  _imageBytes!,
                                  height: 250,
                                  width: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: _showImageSourceSelection,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.deepMauve.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.photo_camera,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Change Photo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SoftButton(
                          onPressed: _analyzeImage,
                          backgroundColor: AppTheme.strongMauve,
                          textColor: Colors.white,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.palette_outlined, size: 20, color: Colors.white),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Analyze My Colors',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Loading section with elegant animation
  Widget _buildLoadingSection() {
    _fadeController.forward();
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SoftCard(
            backgroundColor: Colors.white,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Analyzing Your Colors',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Our AI is validating your photo and analyzing your skin tone, hair color, and eye color to determine your perfect color palette.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Error section with retry option
  Widget _buildErrorSection(String? errorMessage) {
    // Check if this is a face detection error
    final isFaceError = errorMessage?.contains('Please upload a clear photo of your face') == true;
    
    return SoftCard(
      backgroundColor: Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isFaceError ? Colors.amber.shade50 : Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFaceError ? Icons.face_retouching_natural : Icons.error_outline,
                size: 40,
                color: isFaceError ? Colors.amber.shade600 : Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isFaceError ? 'Face Not Detected' : 'Analysis Failed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Something went wrong while analyzing your photo. Please try again.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            
            // Add helpful tips for face detection errors
            if (isFaceError) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips for better results:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...['Take a selfie in natural daylight', 'Face the light source directly', 'Make sure your face fills most of the frame', 'Remove sunglasses or face coverings'].map((tip) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.only(right: 8, top: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tip,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.amber.shade700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            SoftButton(
              onPressed: () {
                Provider.of<ColorProvider>(context, listen: false).resetForNewInput();
                setState(() {
                  _imageBytes = null;
                  _fadeController.reset();
                  _fadeController.forward();
                });
              },
              backgroundColor: isFaceError ? Colors.amber.shade600 : AppTheme.strongMauve,
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFaceError ? Icons.camera_alt_outlined : Icons.refresh, 
                    size: 20, 
                    color: Colors.white
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      isFaceError ? 'Take New Photo' : 'Try Again',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  // Results section with professional layout
  Widget _buildResultsSection(dynamic analysis) {
    _slideController.forward();
    
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color Type Card
          SoftCard(
            backgroundColor: Colors.white,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your Color Type',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    analysis.seasonType ?? 'Unknown',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (analysis.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      analysis.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                            height: 1.6,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Color Palette
          if (analysis.primaryColors != null && analysis.primaryColors!.isNotEmpty) ...[
            SoftCard(
              backgroundColor: Colors.white,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Your Perfect Colors',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Changed from 3 to 4 for more colors
                        childAspectRatio: 0.75, // Slightly adjusted for better proportions
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: analysis.primaryColors!.length,
                      itemBuilder: (context, index) {
                        final color = analysis.primaryColors![index];
                        final colorValue = _hexToColor(color);
                        
                        return GestureDetector(
                          onTap: () => _showFullScreenColorBasic(context, colorValue, color),
                          onLongPress: () => _copyToClipboard(color, context),
                          child: Column(
                            children: [
                              // Color box
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: colorValue,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorValue.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: AppTheme.strongMauve.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.fullscreen,
                                      color: colorValue.computeLuminance() > 0.5 
                                          ? Colors.black38 
                                          : Colors.white38,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Simple tap hint
                              Icon(
                                Icons.touch_app,
                                size: 12,
                                color: AppTheme.textSecondaryColor.withOpacity(0.5),
                              ),
                              const SizedBox(height: 4),
                              // Hex code below
                              Text(
                                color.toUpperCase(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
          
          // Makeup Color Palette
          if (analysis.makeupColors != null && analysis.makeupColors!.isNotEmpty) ...[
            SoftCard(
              backgroundColor: Colors.white,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.strongMauve, AppTheme.accentColor],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Makeup Color Palette',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.face_retouching_natural,
                          size: 20,
                          color: AppTheme.strongMauve,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap any color to see it full screen and get specific application guidance',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor.withOpacity(0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns for makeup colors for better description display
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: analysis.makeupColors!.length,
                      itemBuilder: (context, index) {
                        final makeupColor = analysis.makeupColors![index];
                        final colorValue = _hexToColor(makeupColor.color);
                        
                        return GestureDetector(
                          onTap: () => _showFullScreenColor(
                            context,
                            colorValue,
                            makeupColor.color,
                            makeupColor.usage,
                            makeupColor.description,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.strongMauve.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorValue.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Color preview with usage label
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: colorValue,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Usage label overlay
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              makeupColor.usage,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Full screen hint
                                        const Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Icon(
                                            Icons.fullscreen,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Information section
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Hex code
                                        Text(
                                          makeupColor.color.toUpperCase(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppTheme.strongMauve,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Description
                                        Expanded(
                                          child: Text(
                                            makeupColor.description,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.textSecondaryColor,
                                              fontSize: 10,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
          
          // Recommendations
          if (analysis.styleTips != null && analysis.styleTips!.isNotEmpty) ...[
            SoftCard(
              backgroundColor: Colors.white,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Style Recommendations',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...analysis.styleTips!.map<Widget>((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 8, right: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.strongMauve,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              tip,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Action buttons based on current state
  Widget _buildActionButtons(dynamic analysis, bool isLoading, bool hasError, ColorProvider colorProvider) {
    if (isLoading) return const SizedBox.shrink();

    if (hasError) {
      return SoftButton(
        onPressed: () {
          Provider.of<ColorProvider>(context, listen: false).resetForNewInput();
          setState(() {
            _imageBytes = null;
            _fadeController.reset();
            _fadeController.forward();
          });
        },
        backgroundColor: AppTheme.strongMauve,
        textColor: Colors.white,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (analysis != null) {
      return Column(
        children: [
          Row(
            children: [
              // Icon-only Save button
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Provider.of<ColorProvider>(context, listen: false).saveAnalysis();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Analysis saved successfully!'),
                        backgroundColor: AppTheme.strongMauve,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    colorProvider.isCurrentAnalysisSaved 
                        ? Icons.favorite 
                        : Icons.favorite_outline,
                    size: 24,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Expanded Try Again button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<ColorProvider>(context, listen: false).resetForNewInput();
                    setState(() {
                      _imageBytes = null;
                      _fadeController.reset();
                      _fadeController.forward();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.strongMauve,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _pickImageFromCamera() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _fadeController.forward();
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      _fadeController.forward();
    }
  }

  void _analyzeImage() {
    if (_imageBytes != null) {
      // Show loading immediately since we're about to start analysis
      Provider.of<ColorProvider>(context, listen: false)
        .analyzePersonalColorType(_imageBytes!);
      _slideController.reset();
    }
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // Copy hex color to clipboard
  Future<void> _copyToClipboard(String hexColor, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: hexColor.toUpperCase()));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Color ${hexColor.toUpperCase()} copied to clipboard!'),
          backgroundColor: AppTheme.strongMauve,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Show full screen color preview
  void _showFullScreenColor(
    BuildContext context,
    Color color,
    String hexCode,
    String usage,
    String description,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenColorPreview(
          color: color,
          hexCode: hexCode,
          usage: usage,
          description: description,
        ),
      ),
    );
  }

  // Show full screen color preview for basic colors
  void _showFullScreenColorBasic(
    BuildContext context,
    Color color,
    String hexCode,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenColorPreview(
          color: color,
          hexCode: hexCode,
          usage: "Perfect Color",
          description: "This color complements your skin tone perfectly. Use it for clothing, accessories, or makeup to enhance your natural beauty.",
        ),
      ),
    );
  }
  
  // Show image source selection bottom sheet
  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) { // Renamed context to avoid conflict
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Choose Image Source',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SourceOptionButton(
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    onTap: () {
                      Navigator.pop(sheetContext); // Use sheetContext here
                      _pickImageFromCamera();
                    },
                  ),
                  _SourceOptionButton(
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    onTap: () {
                      Navigator.pop(sheetContext); // Use sheetContext here
                      _pickImage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
} // This closes _ColorAnalysisScreenState

class _SourceOptionButton extends StatelessWidget {
  const _SourceOptionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
