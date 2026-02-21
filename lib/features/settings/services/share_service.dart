import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Card and controller
import 'package:quitease/features/settings/presentation/controllers/profile_controller.dart';
import 'package:quitease/features/settings/presentation/widgets/profile_shareable_card.dart';

class ShareService {
  static Future<void> captureAndShareProfileCard(BuildContext context) async {
    // Show loading dialog
    Get.dialog(
      const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Creating image..."),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // This key is created on-the-fly
    final GlobalKey globalKey = GlobalKey();
    OverlayEntry? entry;

    try {
      // 1. Find the controller that is ALREADY ALIVE
      // This is safe because we're calling this *from* the ProfileScreen
      final ProfileController controller = Get.find<ProfileController>();

      // 2. Define the widget to be captured
      Widget captureWidget = RepaintBoundary(
        key: globalKey,
        child: ProfileShareableCard(controller: controller),
      );

      // 3. Create the OverlayEntry
      entry = OverlayEntry(
        builder: (context) => Positioned(
          left: -9999.0, // Position it off-screen
          top: 0.0,
          // Wrap in a GetMaterialApp to provide theme and GetX dependencies
          child: Material(
            child: Theme(
              data: Theme.of(context),
              child: Directionality(
                // We still need directionality, usually LTR is fine for most apps.
                // If your app supports RTL, you might want to keep using
                // Directionality.of(context) instead.
                // textDirection: TextDirection.ltr,
                textDirection: Directionality.of(context),
                child: captureWidget,
              ),
            ),
          ),
        ),
      );

      // 4. Insert the entry into the Overlay
      Overlay.of(context).insert(entry);

      // 5. Wait for the widget to render (especially for the network image)
      await Future.delayed(const Duration(milliseconds: 500));

      // 6. Capture the image
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // ---  Convert the widget to an image ---
      ui.Image image = await boundary.toImage(pixelRatio: 3.0); // High quality

      // ---  Convert image to byte data (PNG format) ---
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return;
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // 7. Save and share
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/my_quit_journey.png').create();
      await file.writeAsBytes(pngBytes);
      final xFile = XFile(file.path);
      debugPrint("Image saved to: ${file.path}");

      // Hide loading dialog *before* opening share sheet
      Get.back();

      await Share.shareXFiles(
        [xFile],
        text: 'Check out my progress on my quit journey!',
        subject: 'My Smoking Quit Journey',
      );
      debugPrint('✅ Progress shared successfully as image');
    } catch (e) {
      Get.back(); // Hide loading dialog on error
      Get.snackbar(
        'Share Failed',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('❌ Error capturing widget: $e');
    } finally {
      // 8. CRITICAL: Always remove the entry to prevent memory leaks
      entry?.remove();
    }
  }
}
