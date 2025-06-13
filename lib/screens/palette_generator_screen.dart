import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/soft_button.dart';
import '../widgets/soft_card.dart';

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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: AppTheme.textPrimaryColor,
            ),
            actions: [
              if (palette != null)
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    colorProvider.savePalette();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Palette saved to favorites'),
                        backgroundColor: AppTheme.primaryColor,
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
                          const ChatBubble(
                            message: 'Upload an image to create a beautiful color palette.',
                            isUser: false,
                          ),
                          const SizedBox(height: 16),

                          // Image picker section
                          if (_imageBytes == null && !isLoading && palette == null)
                            _buildImagePickerSection(),

                          // Selected image preview
                          if (_imageBytes != null)
                            SoftCard(
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.memory(
                                  _imageBytes!,
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Loading state
                          if (isLoading)
                            const Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: AppTheme.secondaryColor,
                                  ),
                                  SizedBox(height: 16),
                                  Text('Generating palette...'),
                                ],
                              ),
                            ),

                          // Error state
                          if (hasError)
                            Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    colorProvider.errorMessage ?? 'An error occurred',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 16),
                                  SoftButton(
                                    onPressed: () => _pickImage(),
                                    child: const Text('Try Again'),
                                    backgroundColor: AppTheme.secondaryColor,
                                  ),
                                ],
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
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      palette.name,
                                      style: Theme.of(context).textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      palette.description ?? 'Generated palette from your image',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 24),
                                    FadeTransition(
                                      opacity: _animation,
                                      child: Column(
                                        children: [
                                          _buildColorPalette(palette.colors),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Mood: ${palette.mood ?? 'Not specified'}',
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.w500,
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
                            SoftCard(
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Usage Tips',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 12),
                                    ...(palette.usageTips ?? []).map((tip) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                size: 18,
                                                color: AppTheme.secondaryColor,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(tip),
                                              ),
                                            ],
                                          ),
                                        )),
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
                      child: SoftButton(
                        onPressed: _imageBytes == null ? () => _pickImage() : () => _generatePalette(),
                        child: Text(_imageBytes == null ? 'Upload Image' : 'Generate Palette'),
                        backgroundColor: AppTheme.secondaryColor,
                        width: double.infinity,
                      ),
                    ),

                  // Try another image button when palette is complete
                  if (palette != null && !isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: SoftButton(
                        onPressed: () {
                          colorProvider.resetCurrentPalette();
                          setState(() {
                            _imageBytes = null;
                            _controller.reset();
                          });
                        },
                        child: const Text('Try Another Image'),
                        backgroundColor: AppTheme.secondaryColor,
                        width: double.infinity,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.image,
              size: 48,
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Upload an image',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a photo with colors you love to create a harmonious palette',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPalette(List<String> colors) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppTheme.softShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: colors.map((colorHex) {
            final color = _hexToColor(colorHex);
            return Expanded(
              child: Container(
                color: color,
                height: 80,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      colorHex.toUpperCase(),
                      style: TextStyle(
                        color: _isLightColor(color) ? Colors.black : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
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

  bool _isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }
}
