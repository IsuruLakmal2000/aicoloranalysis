import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/soft_card.dart';
import '../widgets/full_screen_color_preview.dart';

class PaletteGeneratorScreen extends StatefulWidget {
  const PaletteGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<PaletteGeneratorScreen> createState() => _PaletteGeneratorScreenState();
}

class _PaletteGeneratorScreenState extends State<PaletteGeneratorScreen>
    with SingleTickerProviderStateMixin {
  Uint8List? _imageBytes;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        final palette = colorProvider.currentPalette;
        final isLoading = colorProvider.status == AnalysisStatus.loading;
        final hasError = colorProvider.status == AnalysisStatus.error;

        // Start animation when palette is loaded
        if (palette != null && !_controller.isCompleted) {
          _controller.forward();
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Palette Generator',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimaryColor,
              ),
            ),
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false, // Remove back button
            actions: [
              if (palette != null)
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    colorProvider.savePalette();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Palette saved to favorites'),
                        backgroundColor: AppTheme.deepMauve,
                      ),
                    );
                  },
                ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ChatBubble(
                            message: 'Upload an image to create a beautiful color palette inspired by your photo.',
                            isUser: false,
                          ),
                          const SizedBox(height: 24),

                          // Image picker section
                          if (_imageBytes == null && !isLoading && palette == null)
                            _buildImagePickerSection(),

                          // Selected image preview
                          if (_imageBytes != null)
                            Column(
                              children: [
                                SoftCard(
                                  backgroundColor: Colors.white,
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: AppTheme.primaryColor.withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: Image.memory(
                                            _imageBytes!,
                                            height: 300,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: _pickImage,
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
                                ),
                              ],
                            ),

                          const SizedBox(height: 24),

                          // Loading state
                          if (isLoading)
                            Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: AppTheme.deepMauve,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Generating palette...',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Error state
                          if (hasError)
                            SoftCard(
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.error_outline,
                                        color: AppTheme.deepMauve,
                                        size: 48,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Error Generating Palette',
                                      style: TextStyle(
                                        color: AppTheme.textPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      colorProvider.errorMessage ?? 'An error occurred while generating your color palette.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () {
                                        colorProvider.resetForNewInput();
                                        setState(() {
                                          _imageBytes = null;
                                          _controller.reset();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.deepMauve,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Try Again',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Color palette result
                          if (palette != null) ...[
                            ChatBubble(
                              message: palette.name,
                              isUser: false,
                            ),
                            const SizedBox(height: 16),
                            SoftCard(
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            palette.name,
                                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                              color: AppTheme.textPrimaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0),
                                      child: Text(
                                        palette.description ?? 'Generated palette from your image',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    FadeTransition(
                                      opacity: _animation,
                                      child: Column(
                                        children: [
                                          _buildColorPalette(palette.colors),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: AppTheme.secondaryColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppTheme.secondaryColor.withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.mood,
                                                  size: 16,
                                                  color: AppTheme.deepMauve,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  palette.mood ?? 'Not specified',
                                                  style: TextStyle(
                                                    color: AppTheme.textPrimaryColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (palette.usageTips != null && palette.usageTips!.isNotEmpty)
                              SoftCard(
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          'Usage Tips',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: AppTheme.textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...palette.usageTips!.map((tip) => Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 18,
                                                  color: AppTheme.primaryColor,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    tip,
                                                    style: TextStyle(
                                                      color: AppTheme.textPrimaryColor,
                                                      height: 1.4,
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
                    ),
                  ),

                  // Bottom action button
                  if (!isLoading && palette == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _imageBytes == null ? _pickImage : _generatePalette,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.deepMauve,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _imageBytes == null ? Icons.upload : Icons.auto_fix_high,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _imageBytes == null ? 'Upload Image' : 'Generate Palette',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Try another image button when palette is complete
                  if (palette != null && !isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          colorProvider.resetCurrentPalette();
                          setState(() {
                            _imageBytes = null;
                            _controller.reset();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.deepMauve,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Try Another Image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePickerSection() {
    return SoftCard(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                Icons.color_lens,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create Color Palette',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Upload an image with colors you love to generate a harmonious palette for your project',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPalette(List<String> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Color Palette',
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${colors.length} Colors',
                style: TextStyle(
                  color: AppTheme.deepMauve,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [AppTheme.softShadow],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: List.generate(
                colors.length,
                (index) {
                  final colorHex = colors[index];
                  final color = _hexToColor(colorHex);
                  // Animate each color swatch with a slight delay
                  return AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      // Staggered animation based on index
                      final delayedValue = _animation.value - (index * 0.1);
                      final animValue = delayedValue.clamp(0.0, 1.0);
                      
                      return Expanded(
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * animValue),
                          child: Opacity(
                            opacity: animValue,
                            child: GestureDetector(
                              onTap: () => _showFullScreenColorPalette(context, color, colorHex),
                              child: Container(
                                color: color,
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Full screen hint icon
                                    Expanded(
                                      child: Center(
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: _isLightColor(color) 
                                              ? Colors.black.withOpacity(0.26) 
                                              : Colors.white.withOpacity(0.26),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      color: Colors.black.withOpacity(0.15),
                                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 4,
                                            width: 20,
                                            margin: const EdgeInsets.only(bottom: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          Text(
                                            colorHex.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: _isLightColor(color) ? AppTheme.textPrimaryColor : Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
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
                  _buildSourceOption(
                    context: context,
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    onTap: () => _getImage(ImageSource.camera),
                  ),
                  _buildSourceOption(
                    context: context,
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    onTap: () => _getImage(ImageSource.gallery),
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

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
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

  Future<void> _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _generatePalette() {
    if (_imageBytes != null) {
      Provider.of<ColorProvider>(context, listen: false).generatePaletteFromImage(_imageBytes!);
    }
  }

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // Show full screen color preview for palette colors
  void _showFullScreenColorPalette(
    BuildContext context,
    Color color,
    String hexCode,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenColorPreview(
          color: color,
          hexCode: hexCode,
          usage: "Palette Color",
          description: "This color is part of your generated palette. Use it in your design projects, branding, or creative work to create harmonious color schemes.",
        ),
      ),
    );
  }

  bool _isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }
}
