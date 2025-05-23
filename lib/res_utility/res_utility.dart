import 'package:flutter/material.dart';

/// A comprehensive responsive utility class for Flutter apps
/// Handles screen dimensions, orientation, aspect ratio, and density scaling
class ResponsiveUtils {
  final BuildContext context;

  // Core screen properties
  late final double screenWidth;
  late final double screenHeight;
  late final double smallerDimension;
  late final double largerDimension;
  late final bool isLandscape;
  late final double aspectRatio;
  late final double pixelRatio;
  late final double fontMultiplier;

  ResponsiveUtils(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    smallerDimension = screenWidth < screenHeight ? screenWidth : screenHeight;
    largerDimension = screenWidth > screenHeight ? screenWidth : screenHeight;

    // Orientation detection
    isLandscape = screenWidth > screenHeight;

    // Aspect ratio calculations
    aspectRatio = screenWidth / screenHeight;
    fontMultiplier =
        aspectRatio > 1.5 ? 1.2 : 1.0; // Bigger fonts on wide screens

    // Device pixel ratio
    pixelRatio = MediaQuery.of(context).devicePixelRatio;
  }

  /// Get adaptive size based on orientation
  /// Uses height in landscape, width in portrait for better proportions
  double getAdaptiveSize(double percentage) {
    double adaptiveSize =
        isLandscape ? screenHeight * percentage : screenWidth * percentage;
    return adaptiveSize;
  }

  /// Get density-adjusted size to maintain consistent physical dimensions
  double getDensityAdjustedSize(double baseSize) {
    return baseSize / pixelRatio;
  }

  /// Get responsive font size with aspect ratio consideration
  double getResponsiveFontSize(
    double baseSize, {
    double? minSize,
    double? maxSize,
  }) {
    double responsiveSize = (baseSize * fontMultiplier);

    if (minSize != null && maxSize != null) {
      return responsiveSize.clamp(minSize, maxSize);
    }
    return responsiveSize;
  }

  /// Get spacing based on screen dimensions
  double getSpacing(
    double percentage, {
    double? minSpacing,
    double? maxSpacing,
  }) {
    double spacing = smallerDimension * percentage;

    if (minSpacing != null && maxSpacing != null) {
      return spacing.clamp(minSpacing, maxSpacing);
    }
    return spacing;
  }

  /// Get padding based on screen width
  double getPadding(
    double percentage, {
    double? minPadding,
    double? maxPadding,
  }) {
    double padding = screenWidth * percentage;

    if (minPadding != null && maxPadding != null) {
      return padding.clamp(minPadding, maxPadding);
    }
    return padding;
  }

  /// Get image size with orientation consideration
  double getImageSize(double percentage, {double? minSize, double? maxSize}) {
    double imageSize = getAdaptiveSize(percentage);

    if (minSize != null && maxSize != null) {
      return imageSize.clamp(minSize, maxSize);
    }
    return imageSize;
  }

  /// Get button dimensions with aspect ratio consideration
  ButtonDimensions getButtonDimensions({
    double widthPercentage = 0.4,
    double heightPercentage = 0.07,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    double width = screenWidth * widthPercentage;
    double height = screenHeight * heightPercentage;

    // Adjust for aspect ratio
    if (aspectRatio > 1.5) {
      width *= 0.8; // Reduce width on very wide screens
    }

    if (minWidth != null && maxWidth != null) {
      width = width.clamp(minWidth, maxWidth);
    }

    if (minHeight != null && maxHeight != null) {
      height = height.clamp(minHeight, maxHeight);
    }

    return ButtonDimensions(width: width, height: height);
  }

  /// Device type detection
  DeviceType get deviceType {
    if (smallerDimension < 600) {
      return DeviceType.mobile;
    } else if (smallerDimension < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Get responsive value with device type consideration
  double getDeviceSpecificValue({
    required double mobileValue,
    required double tabletValue,
    required double desktopValue,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobileValue;
      case DeviceType.tablet:
        return tabletValue;
      case DeviceType.desktop:
        return desktopValue;
    }
  }

  /// Quick access to common responsive values
  ResponsiveValues get values => ResponsiveValues(this);
}

/// Helper class for button dimensions
class ButtonDimensions {
  final double width;
  final double height;

  const ButtonDimensions({required this.width, required this.height});
}

/// Device type enumeration
enum DeviceType { mobile, tablet, desktop }

/// Common responsive values for quick access
class ResponsiveValues {
  final ResponsiveUtils _utils;

  ResponsiveValues(this._utils);

  // Font sizes
  double get titleFontSize =>
      _utils.getResponsiveFontSize(24, minSize: 18, maxSize: 32);
  double get subtitleFontSize =>
      _utils.getResponsiveFontSize(18, minSize: 14, maxSize: 24);
  double get bodyFontSize =>
      _utils.getResponsiveFontSize(16, minSize: 12, maxSize: 20);
  double get buttonFontSize =>
      _utils.getResponsiveFontSize(16, minSize: 14, maxSize: 18);
  double get captionFontSize =>
      _utils.getResponsiveFontSize(12, minSize: 10, maxSize: 16);

  // Spacing
  double get tinySpacing =>
      _utils.getSpacing(0.01, minSpacing: 4, maxSpacing: 8);
  double get smallSpacing =>
      _utils.getSpacing(0.02, minSpacing: 8, maxSpacing: 16);
  double get mediumSpacing =>
      _utils.getSpacing(0.03, minSpacing: 12, maxSpacing: 24);
  double get largeSpacing =>
      _utils.getSpacing(0.05, minSpacing: 20, maxSpacing: 40);
  double get extraLargeSpacing =>
      _utils.getSpacing(0.08, minSpacing: 32, maxSpacing: 64);

  // Padding
  double get smallPadding =>
      _utils.getPadding(0.04, minPadding: 16, maxPadding: 32);
  double get mediumPadding =>
      _utils.getPadding(0.06, minPadding: 24, maxPadding: 48);
  double get largePadding =>
      _utils.getPadding(0.08, minPadding: 32, maxPadding: 64);

  // Common sizes
  double get iconSize => _utils.getAdaptiveSize(0.06).clamp(20, 40);
  double get avatarSize => _utils.getAdaptiveSize(0.12).clamp(40, 80);
  double get cardRadius =>
      _utils.getSpacing(0.02, minSpacing: 8, maxSpacing: 16);
  double get buttonRadius =>
      _utils.getSpacing(0.015, minSpacing: 6, maxSpacing: 12);
}

/// Extension on BuildContext for easy access to ResponsiveUtils
extension ResponsiveContext on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}

/// Example usage widget
class ResponsiveExampleWidget extends StatelessWidget {
  const ResponsiveExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final values = responsive.values;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(values.mediumPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Responsive image
              Container(
                width: responsive.getImageSize(0.6, minSize: 150, maxSize: 300),
                height: responsive.getImageSize(
                  0.6,
                  minSize: 150,
                  maxSize: 300,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(values.cardRadius),
                ),
                child: Icon(
                  Icons.image,
                  size: values.iconSize * 2,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: values.largeSpacing),

              // Responsive text
              Text(
                'Responsive Title',
                style: TextStyle(
                  fontSize: values.titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: values.smallSpacing),

              Text(
                'This text adapts to different screen sizes and orientations',
                style: TextStyle(
                  fontSize: values.bodyFontSize,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: values.largeSpacing),

              // Responsive button
              Builder(
                builder: (context) {
                  final buttonDimensions = responsive.getButtonDimensions(
                    minWidth: 120,
                    maxWidth: 250,
                    minHeight: 45,
                    maxHeight: 60,
                  );

                  return SizedBox(
                    width: buttonDimensions.width,
                    height: buttonDimensions.height,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            values.buttonRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        'Responsive Button',
                        style: TextStyle(
                          fontSize: values.buttonFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: values.mediumSpacing),

              // Device info
              Container(
                padding: EdgeInsets.all(values.smallPadding),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(values.cardRadius),
                ),
                child: Column(
                  children: [
                    Text(
                      'Device Info',
                      style: TextStyle(
                        fontSize: values.subtitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: values.tinySpacing),
                    Text(
                      'Type: ${responsive.deviceType.name.toUpperCase()}',
                      style: TextStyle(fontSize: values.captionFontSize),
                    ),
                    Text(
                      'Orientation: ${responsive.isLandscape ? "Landscape" : "Portrait"}',
                      style: TextStyle(fontSize: values.captionFontSize),
                    ),
                    Text(
                      'Screen: ${responsive.screenWidth.toInt()}x${responsive.screenHeight.toInt()}',
                      style: TextStyle(fontSize: values.captionFontSize),
                    ),
                    Text(
                      'Aspect Ratio: ${responsive.aspectRatio.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: values.captionFontSize),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
