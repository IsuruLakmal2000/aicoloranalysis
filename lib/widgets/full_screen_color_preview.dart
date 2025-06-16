import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class FullScreenColorPreview extends StatelessWidget {
  final Color color;
  final String hexCode;
  final String? usage;
  final String? description;

  const FullScreenColorPreview({
    Key? key,
    required this.color,
    required this.hexCode,
    this.usage,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightColor = color.computeLuminance() > 0.5;
    final textColor = isLightColor ? Colors.black87 : Colors.white;
    final iconColor = isLightColor ? Colors.black54 : Colors.white70;
    
    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: Stack(
          children: [
            // Background color fills entire screen
            Container(color: color),
            
            // Top close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: iconColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Usage type if provided
                  if (usage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        usage!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  
                  // Hex code display
                  GestureDetector(
                    onTap: () => _copyToClipboard(context),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: textColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            hexCode.toUpperCase(),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.copy_outlined,
                                color: iconColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tap to copy',
                                style: TextStyle(
                                  color: iconColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Description if provided
                  if (description != null) ...[
                    const SizedBox(height: 32),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        description!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: hexCode.toUpperCase()));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Color ${hexCode.toUpperCase()} copied to clipboard!'),
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
}
