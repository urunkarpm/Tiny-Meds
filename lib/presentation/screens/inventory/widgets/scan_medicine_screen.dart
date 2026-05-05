import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanMedicineScreen extends StatefulWidget {
  const ScanMedicineScreen({super.key});

  @override
  State<ScanMedicineScreen> createState() => _ScanMedicineScreenState();
}

class _ScanMedicineScreenState extends State<ScanMedicineScreen> {
  CameraController? _controller;
  bool _isPermissionGranted = false;
  bool _isProcessing = false;
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isPermissionGranted = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (mounted) {
        final results = _processText(recognizedText.text);
        Navigator.pop(context, results);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Map<String, dynamic> _processText(String text) {
    // Simple heuristic-based extraction
    String? name;
    String? strength;
    DateTime? expiryDate;

    final lines = text.split('\n');
    
    // 1. Try to find strength (e.g., 500mg, 10ml, 50 mcg)
    final strengthRegExp = RegExp(r'(\d+)\s*(mg|ml|mcg|g|units|capsules|tablets)', caseSensitive: false);
    
    for (var line in lines) {
      final match = strengthRegExp.firstMatch(line);
      if (match != null) {
        strength = match.group(0);
        // Often the name is on the same line or line before
        if (name == null) {
           name = line.replaceAll(strength!, '').trim();
           if (name.length < 3) name = null; // Too short to be a name
        }
      }

      // 2. Try to find expiry date (e.g., EXP 12/2026, 05-2027)
      final dateRegExp = RegExp(r'(EXP|EXPIRY|ED)[:\s]*(\d{2})[/-](\d{2,4})', caseSensitive: false);
      final dateMatch = dateRegExp.firstMatch(line);
      if (dateMatch != null) {
        final month = int.tryParse(dateMatch.group(2) ?? '');
        final yearStr = dateMatch.group(3) ?? '';
        int year = int.tryParse(yearStr) ?? 0;
        if (year < 100) year += 2000;
        
        if (month != null && month >= 1 && month <= 12 && year > 2000) {
          expiryDate = DateTime(year, month, 1);
        }
      }
    }

    // If name still null, just take the longest line that doesn't look like generic info
    if (name == null || name.isEmpty) {
      for (var line in lines) {
        if (line.length > 5 && !line.contains(RegExp(r'\d')) && !line.toLowerCase().contains('exp')) {
          name = line.trim();
          break;
        }
      }
    }

    return {
      'name': name,
      'strength': strength,
      'expiryDate': expiryDate,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scan Medicine', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          if (_isPermissionGranted && _controller != null)
            Center(
              child: CameraPreview(_controller!),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          
          // Overlay for scanning area
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Align the box inside the frame',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _scanImage,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Center(
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
