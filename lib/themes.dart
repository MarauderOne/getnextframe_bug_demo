import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final Map<String, ThemeData> appThemes = {
  'light': ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color.fromRGBO(200, 0, 10, 1),
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: Colors.black,
      tertiary: const Color.fromRGBO(200, 0, 10, 1),
      error: Colors.orange,
      onError: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      onSurfaceVariant: Colors.grey[700]!,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(200, 0, 10, 1),
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromRGBO(200, 0, 10, 1),
      unselectedItemColor: Colors.grey,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
  ),
};

Future<BitmapDescriptor> getColoredMarker(String primaryType, Color color) async {
  late String assetPath;
  if (primaryType == "Food") {
    assetPath = "assets/foodMarker.png";
  }

  if (primaryType == "Shopping") {
    assetPath = "assets/shoppingMarker.png";
  }

  if (primaryType == "Music") {
    assetPath = "assets/musicMarker.png";
  }

  if (primaryType == "Event") {
    assetPath = "assets/eventsMarker.png";
  }

  if (primaryType == "Service") {
    assetPath = "assets/servicesMarker.png";
  }

  try {
    int markerPixelSize = 288;

    // Load the backdrop image (frame)
    final ByteData backdropData = await rootBundle.load("assets/markerIconFrame.png");
    final ui.Codec backdropCodec = await ui.instantiateImageCodec(
      backdropData.buffer.asUint8List(),
      targetWidth: markerPixelSize,
      targetHeight: markerPixelSize,
    );
    // The below line does not seem to work at all in the unit tests, it crashes the function without error
    final ui.FrameInfo backdropFrame = await backdropCodec.getNextFrame();
    final ui.Image backdropImage = backdropFrame.image;

    // Load the base image (to be colorized)
    final ByteData markerData = await rootBundle.load(assetPath);
    final ui.Codec markerCodec = await ui.instantiateImageCodec(
      markerData.buffer.asUint8List(),
      targetWidth: markerPixelSize,
      targetHeight: markerPixelSize,
    );
    // The below line does not seem to work at all in the unit tests, it crashes the function without error
    final ui.FrameInfo markerFrame = await markerCodec.getNextFrame();
    final ui.Image markerImage = markerFrame.image;

    // Create a canvas to draw both images
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Draw the backdrop image without any color filter
    final Paint backdropPaint = Paint(); // No color filter
    canvas.drawImage(backdropImage, Offset.zero, backdropPaint);

    // Draw the marker image on top with the color overlay
    final Paint markerPaint = Paint()..colorFilter = ColorFilter.mode(color, BlendMode.srcIn); // Apply color to the marker image
    canvas.drawImage(markerImage, Offset.zero, markerPaint);

    // Convert the final image to a BitmapDescriptor
    final ui.Image finalImage = await recorder.endRecording().toImage(
      markerImage.width,
      markerImage.height,
    );
    final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(pngBytes, imagePixelRatio: 1.0, height: 48.0, width: 48.0);
  } catch (e) {
    debugPrint("Custom marker rendering failed: $e");
    return BitmapDescriptor.defaultMarker;
  }
}

Color getCategoryColor(String selectedThemeKey, String primaryType) {
  if (selectedThemeKey == "light") {
    if (primaryType == "Food") {
      Color color = const Color.fromRGBO(242, 153, 0, 1.0);
      return color;
    } else if (primaryType == "Shopping") {
      Color color = const Color.fromRGBO(209, 81, 85, 1.0);
      return color;
    } else if (primaryType == "Music") {
      Color color = const Color.fromRGBO(190, 110, 230, 1.0);
      return color;
    } else if (primaryType == "Event") {
      Color color = const Color.fromRGBO(243, 190, 66, 1.0);
      return color;
    } else if (primaryType == "Service") {
      Color color = const Color.fromRGBO(84, 145, 245, 1.0);
      return color;
    }

    // Default colour for markers with no category
    Color color = const Color.fromRGBO(255, 0, 0, 1.0);
    return color;
  } else {
    // Default colour for markers with no theme and no category
    Color color = const Color.fromRGBO(255, 0, 0, 1.0);
    return color;
  }
}
