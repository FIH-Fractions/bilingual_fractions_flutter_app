import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'learn_content.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  bool isEnglish = true;
  late PageController _controller;
  int _currentPage = 0;
  final TextEditingController _numeratorController = TextEditingController();
  final TextEditingController _denominatorController = TextEditingController();
  double _fillPercentage = 0.0;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _flutterTts = FlutterTts();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setSpeechRate(0.8);
    await _updateTtsLanguage();
  }

  Future<void> _updateTtsLanguage() async {
    final languageCode = isEnglish ? 'en-US' : 'es-ES';
    await _flutterTts.setLanguage(languageCode);
  }

  void _updateFillPercentage() {
    final numerator = int.tryParse(_numeratorController.text);
    final denominator = int.tryParse(_denominatorController.text);

    if (numerator != null && denominator != null && denominator > 0) {
      setState(() {
        _fillPercentage = (numerator / denominator).clamp(0.0, 1.0);
      });
    }
  }

  Future<void> _speakFraction() async {
    final numerator = int.tryParse(_numeratorController.text);
    final denominator = int.tryParse(_denominatorController.text);

    if (numerator == null || denominator == null || denominator == 0) {
      return;
    }

    final phrase = isEnglish
        ? '$numerator over $denominator'
        : '$numerator sobre $denominator';

    await _flutterTts.stop();
    await _flutterTts.speak(phrase);
  }

  @override
  void dispose() {
    _controller.dispose();
    _numeratorController.dispose();
    _denominatorController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.translate_rounded,
                  size: 30, color: Colors.black),
              onPressed: () async {
                setState(() => isEnglish = !isEnglish);
                await _updateTtsLanguage();
                await FirebaseFirestore.instance
                    .collection('analytics')
                    .doc('learn_section_translate')
                    .set(
                  {'count': FieldValue.increment(1)},
                  SetOptions(merge: true),
                );
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: learnSlides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final slide = learnSlides[index];
                final isLastSlide = index == learnSlides.length - 1;

                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (slide.imagePath != null)
                        SizedBox(
                          width: 530,
                          height: 350,
                          child: Image.asset(slide.imagePath!,
                              fit: BoxFit.contain),
                        ),
                      if (slide.imagePath != null) const SizedBox(height: 20),
                      if (slide.titleEn.isNotEmpty)
                        Text(
                          isEnglish ? slide.titleEn : slide.titleEs,
                          style: const TextStyle(
                              fontSize: 44, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 20),
                      Text(
                        isEnglish ? slide.descEn : slide.descEs,
                        style: const TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      if (isLastSlide) ...[
                        const SizedBox(height: 40),
                        _buildInteractiveFractionVisualizer(),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF8F87F1), // use #8F87F1 for active
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _currentPage > 0
                    ? () => _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        )
                    : null,
                child: const Text('Previous'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF8F87F1), // use #8F87F1 for active
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _currentPage < learnSlides.length - 1
                    ? () => _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        )
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildInteractiveFractionVisualizer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Fraction input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Numerator input
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _numeratorController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '1',
                        filled: true,
                        fillColor: const Color(0xFFF5F3FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF8F87F1), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF8F87F1), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF8F87F1), width: 3),
                        ),
                      ),
                      onChanged: (_) => _updateFillPercentage(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 80,
                    height: 4,
                    color: const Color(0xFF8F87F1),
                  ),
                  const SizedBox(height: 12),
                  // Denominator input
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _denominatorController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '2',
                        filled: true,
                        fillColor: const Color(0xFFF5F3FF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF8F87F1), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF8F87F1), width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF8F87F1), width: 3),
                        ),
                      ),
                      onChanged: (_) => _updateFillPercentage(),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8F87F1),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _speakFraction,
                icon: const Icon(Icons.volume_up_rounded),
                label: Text(isEnglish ? 'Pronounce' : 'Pronunciar'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Glass with water
          AnimatedWaterGlass(fillPercentage: _fillPercentage),
          const SizedBox(height: 20),
          // Percentage display
          Text(
            '${(_fillPercentage * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8F87F1),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom widget for animated water glass
class AnimatedWaterGlass extends StatelessWidget {
  final double fillPercentage;

  const AnimatedWaterGlass({
    super.key,
    required this.fillPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: fillPercentage),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedValue, child) {
        return SizedBox(
          width: 200,
          height: 300,
          child: CustomPaint(
            painter: WaterGlassPainter(fillPercentage: animatedValue),
          ),
        );
      },
    );
  }
}

class WaterGlassPainter extends CustomPainter {
  final double fillPercentage;

  WaterGlassPainter({required this.fillPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    // Draw water
    if (fillPercentage > 0) {
      final waterHeight = size.height * 0.9 * fillPercentage;
      final waterTop = size.height * 0.9 - waterHeight;

      // Water gradient
      final waterGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF64B5F6).withOpacity(0.7),
          const Color(0xFF1976D2).withOpacity(0.8),
        ],
      );

      paint.shader = waterGradient.createShader(
        Rect.fromLTWH(
          size.width * 0.1,
          waterTop,
          size.width * 0.8,
          waterHeight,
        ),
      );

      // Draw water with slight curve at top
      final waterPath = Path();
      waterPath.moveTo(size.width * 0.15, size.height * 0.9);
      waterPath.lineTo(size.width * 0.15, waterTop + 5);

      // Add wave effect at the top of water
      waterPath.quadraticBezierTo(
        size.width * 0.35,
        waterTop,
        size.width * 0.5,
        waterTop + 2,
      );
      waterPath.quadraticBezierTo(
        size.width * 0.65,
        waterTop + 4,
        size.width * 0.85,
        waterTop + 5,
      );

      waterPath.lineTo(size.width * 0.85, size.height * 0.9);

      // Bottom curve of glass
      waterPath.quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.95,
        size.width * 0.15,
        size.height * 0.9,
      );

      canvas.drawPath(waterPath, paint);

      // Add water shine effect
      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final shinePath = Path();
      shinePath.moveTo(size.width * 0.2, waterTop + 10);
      shinePath.lineTo(size.width * 0.25, waterTop + 10);
      shinePath.lineTo(size.width * 0.25, waterTop + 80);
      shinePath.lineTo(size.width * 0.2, waterTop + 60);
      shinePath.close();
      canvas.drawPath(shinePath, shinePaint);
    }

    // Draw glass outline
    paint.shader = null;
    paint.color = const Color(0xFF90A4AE);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;

    final glassPath = Path();
    glassPath.moveTo(size.width * 0.2, 0);
    glassPath.lineTo(size.width * 0.15, size.height * 0.9);

    // Bottom curve
    glassPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.95,
      size.width * 0.85,
      size.height * 0.9,
    );

    glassPath.lineTo(size.width * 0.8, 0);

    canvas.drawPath(glassPath, paint);

    // Add glass rim (top)
    paint.color = const Color(0xFF78909C);
    paint.strokeWidth = 5;
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.8, 0),
      paint,
    );

    // Add glass shine
    final glassShine = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width * 0.82, size.height * 0.1),
      Offset(size.width * 0.84, size.height * 0.7),
      glassShine,
    );
  }

  @override
  bool shouldRepaint(WaterGlassPainter oldDelegate) {
    return oldDelegate.fillPercentage != fillPercentage;
  }
}
