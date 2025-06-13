# AuraColor - AI Powered Color Analysis App

A Flutter-based mobile app that uses Google's Gemini AI to analyze personal colors, generate color palettes from images, and provide color psychology insights. The app has a soft, feminine UI aesthetic and stores all data locally using Hive.

## Features

- **Personal Color Analysis**: Upload a selfie to discover your seasonal color type (Spring, Summer, Autumn, Winter) with personalized style tips
- **Color Palette Generator**: Create harmonious color palettes from any image with mood analysis and usage tips
- **Color Psychology**: Explore the meaning and cultural significance behind different colors
- **Local Storage**: Save your favorite color analyses, palettes, and meanings
- **Conversational UI**: Interact with a friendly AI assistant through a chat-like interface
- **Soft, Minimalist Design**: Beautiful and clean interface with soft shadows and pastel colors

## Getting Started

### Prerequisites

- Flutter SDK (v3.8 or higher)
- Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)

### Installation

1. Clone the repository
   ```sh
   git clone https://github.com/yourusername/aura_color.git
   ```

2. Install dependencies
   ```sh
   flutter pub get
   ```

3. Create a `.env` file in the root directory and add your Gemini API key
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

4. Run the app
   ```sh
   flutter run
   ```

## Project Structure

```
lib/
  ├── main.dart                # App entry point
  ├── models/                  # Data models with Hive integration
  │   ├── color_analysis.dart
  │   ├── color_meaning.dart
  │   └── color_palette.dart
  ├── providers/               # State management
  │   ├── color_provider.dart
  │   └── onboarding_provider.dart
  ├── screens/                 # App screens
  │   ├── onboarding_screen.dart
  │   ├── home_screen.dart
  │   ├── color_analysis_screen.dart
  │   ├── palette_generator_screen.dart
  │   ├── color_psychology_screen.dart
  │   └── collection_screen.dart
  ├── services/                # API and storage services
  │   ├── gemini_service.dart
  │   └── storage_service.dart
  ├── theme/                   # App theme and styling
  │   └── app_theme.dart
  ├── utils/                   # Utility functions
  │   └── color_utils.dart
  └── widgets/                 # Reusable UI components
      ├── soft_button.dart
      ├── soft_card.dart
      └── chat_bubble.dart
```

## Technologies Used

- [Flutter](https://flutter.dev/) - UI framework
- [Provider](https://pub.dev/packages/provider) - State management
- [Hive](https://pub.dev/packages/hive) - Local data persistence
- [Google Gemini API](https://ai.google.dev/) - AI for color analysis
- [Image Picker](https://pub.dev/packages/image_picker) - Image selection
- [Palette Generator](https://pub.dev/packages/palette_generator) - Color extraction

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Google Gemini for AI capabilities
- Flutter team for the amazing framework
- Open source community for the packages used
