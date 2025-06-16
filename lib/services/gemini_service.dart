import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/color_analysis.dart';
import '../models/color_meaning.dart';
import '../models/color_palette.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in environment variables');
    }
    
    // Use Gemini 1.5 Flash - supports both text and vision in one model
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  // Check if image contains a clearly visible face
  Future<bool> validateFaceInImage(Uint8List imageBytes) async {
    try {
      final prompt = '''
        Analyze this image and determine if it contains a clearly visible human face suitable for color analysis.
        
        Return ONLY "true" if:
        - There is a clear, unobstructed human face
        - The face takes up a reasonable portion of the image
        - Facial features (eyes, skin tone) are clearly visible
        - The lighting allows for accurate color analysis
        
        Return ONLY "false" if:
        - No human face is visible
        - The image contains animals, landscapes, objects, etc.
        - The face is too small, blurry, or poorly lit
        - Multiple faces are present
        - Face is heavily obstructed by accessories
        
        Respond with only "true" or "false".
      ''';

      final content = [
        Content.text(prompt),
        Content.data('image/jpeg', imageBytes),
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text?.trim().toLowerCase();
      
      return responseText == 'true';
    } catch (e) {
      // If validation fails, assume it's not a suitable face image
      return false;
    }
  }

  // Analyze selfie and generate personal color type
  Future<ColorAnalysis> analyzePersonalColorType(Uint8List imageBytes) async {
    try {
      // First validate that the image contains a suitable face
      final hasSuitableFace = await validateFaceInImage(imageBytes);
      if (!hasSuitableFace) {
        throw Exception('Please upload a clear photo of your face. Make sure your face is clearly visible and well-lit for accurate color analysis.');
      }

      final prompt = '''
        Analyze the user's selfie and return their seasonal color type, 
        expanded matching color palette (10-12 colors in HEX), makeup colors with specific usage guidance, and styling advice. 
        Respond in JSON format with the following structure:
        {
          "season_type": "Summer", 
          "primary_colors": ["#E3DFFF", "#BFD4E7", "#A1C2DD", "#95A5A6", "#D5DBDB", "#85C1E9", "#AED6F1", "#A9CCE3", "#D6EAF8", "#EBF5FB", "#F8F9FA", "#FADBD8"],
          "makeup_colors": [
            {"color": "#F1948A", "usage": "Blush", "description": "Perfect for adding a natural flush to your cheeks"},
            {"color": "#EC7063", "usage": "Lipstick", "description": "A beautiful everyday lip color that complements your skin tone"},
            {"color": "#D7BDE2", "usage": "Eyeshadow", "description": "Ideal for creating soft, romantic eye looks"},
            {"color": "#BB8FCE", "usage": "Eyeliner", "description": "A softer alternative to black liner that enhances your eyes"},
            {"color": "#A569BD", "usage": "Highlighter", "description": "Adds a subtle glow to your cheekbones and inner corners"},
            {"color": "#8E44AD", "usage": "Contour", "description": "Perfect for defining your features naturally"}
          ],
          "description": "You belong to the Summer season, best suited for cool, soft colors. These enhance your calm and elegant tone.",
          "style_tips": ["Pastel shades look great on you.", "Avoid harsh blacks or bright oranges.", "Try soft pinks and blues for makeup.", "Silver jewelry complements your coloring better than gold."]
        }
      ''';

      final content = [
        Content.text(prompt),
        Content.data('image/jpeg', imageBytes),
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text;
      
      if (responseText == null) {
        throw Exception('Empty response from Gemini API');
      }

      // Parse the JSON string within the response
      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0 || jsonEnd <= jsonStart) {
        throw Exception('Invalid JSON response from Gemini API');
      }
      
      final jsonString = responseText.substring(jsonStart, jsonEnd);
      final Map<String, dynamic> jsonResponse = json.decode(jsonString);

      return ColorAnalysis.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to analyze color type: $e');
    }
  }

  // Generate color palette from image
  Future<ColorPalette> generatePaletteFromImage(Uint8List imageBytes) async {
    try {
      final prompt = '''
        Generate a beautiful color palette based on this image and return 
        color swatches in HEX with style context. 
        Respond in JSON format with the following structure:
        {
          "name": "Ocean Breeze",
          "colors": ["#A4C2F4", "#D0E0E3", "#76A5AF", "#3D85C6", "#E6F3FF"],
          "description": "A refreshing palette inspired by coastal elements.",
          "mood": "Calm and serene",
          "usage_tips": ["Perfect for bathroom decor", "Works well for a coastal-themed website"]
        }
      ''';

      final content = [
        Content.text(prompt),
        Content.data('image/jpeg', imageBytes),
      ];

      final response = await _model.generateContent(content);
      final responseText = response.text;
      
      if (responseText == null) {
        throw Exception('Empty response from Gemini API');
      }

      // Parse the JSON string within the response
      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0 || jsonEnd <= jsonStart) {
        throw Exception('Invalid JSON response from Gemini API');
      }
      
      final jsonString = responseText.substring(jsonStart, jsonEnd);
      final Map<String, dynamic> jsonResponse = json.decode(jsonString);

      return ColorPalette.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to generate color palette: $e');
    }
  }
  
  // Get color psychology insights
  Future<ColorMeaning> getColorPsychology(String colorHex) async {
    try {
      final prompt = '''
        Analyze the psychology and meaning behind the color $colorHex.
        Respond in JSON format with the following structure:
        {
          "color_name": "Cerulean Blue",
          "hex_code": "$colorHex",
          "short_description": "A calm and soothing blue with hints of green.",
          "psychological_effects": "Promotes relaxation and tranquility. Associated with clarity and communication.",
          "cultural_associations": "In many Western cultures, blue represents trust and dependability. In Eastern cultures like China, blue is associated with immortality.",
          "common_uses": ["Corporate branding for trust", "Spa and wellness products", "Tech interfaces for user comfort"]
        }
      ''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null) {
        throw Exception('Empty response from Gemini API');
      }

      // Parse the JSON string within the response
      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0 || jsonEnd <= jsonStart) {
        throw Exception('Invalid JSON response from Gemini API');
      }
      
      final jsonString = responseText.substring(jsonStart, jsonEnd);
      final Map<String, dynamic> jsonResponse = json.decode(jsonString);
      
      // Add the hex code to the response if it's not already there
      if (!jsonResponse.containsKey('hex_code')) {
        jsonResponse['hex_code'] = colorHex;
      }

      return ColorMeaning.fromJson(jsonResponse);
    } catch (e) {
      throw Exception('Failed to get color psychology: $e');
    }
  }
}
