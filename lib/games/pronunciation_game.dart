import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:io';
import '../services/gemini_chat_service.dart';
import '../services/whisper_service.dart';

class PronunciationGame extends StatefulWidget {
  @override
  _PronunciationGameState createState() => _PronunciationGameState();
}

class FractionData {
  final String numerator;
  final String denominator;
  final String englishPronunciation;
  final String spanishPronunciation;

  FractionData({
    required this.numerator,
    required this.denominator,
    required this.englishPronunciation,
    required this.spanishPronunciation,
  });

  String get fractionDisplay => '$numerator/$denominator';
}

// Game data - 5 sample fractions as requested
final List<FractionData> fractionSet = [
  FractionData(
    numerator: '1',
    denominator: '2',
    englishPronunciation: 'one half',
    spanishPronunciation: 'un medio',
  ),
  FractionData(
    numerator: '1',
    denominator: '4',
    englishPronunciation: 'one fourth',
    spanishPronunciation: 'un cuarto',
  ),
  FractionData(
    numerator: '3',
    denominator: '4',
    englishPronunciation: 'three fourths',
    spanishPronunciation: 'tres cuartos',
  ),
  FractionData(
    numerator: '2',
    denominator: '3',
    englishPronunciation: 'two thirds',
    spanishPronunciation: 'dos tercios',
  ),
  FractionData(
    numerator: '5',
    denominator: '8',
    englishPronunciation: 'five eighths',
    spanishPronunciation: 'cinco octavos',
  ),
];

final List<Color> boxColors = [
  Color(0xFF7ABDA9),
  Color(0xFFC68EFD),
  Color(0xFFE9A5F1),
  Color(0xFFFED2E2),
  Color(0xFFF16767),
];

final Color randomBoxColor = boxColors[Random().nextInt(boxColors.length)];

class _PronunciationGameState extends State<PronunciationGame> {
  // Speech recognition and TTS
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  late AudioRecorder _audioRecorder;
  bool _isListening = false;
  bool _isRecording = false;
  String _recognizedWords = '';
  bool _useWhisper = true; // Toggle between Whisper and built-in STT

  // Game state
  int _currentIndex = 0;
  bool _isEnglishMode = true; // Alternates between English and Spanish
  bool _hasAnswered = false;
  bool _isCorrect = false;
  String _feedback = '';

  // Chat functionality
  TextEditingController _chatController = TextEditingController();
  List<Map<String, String>> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _initSpeech();
    _initTts();
    // Start with English mode by default
    setState(() {
      _isEnglishMode = true;
    });
    _checkWhisperAvailability();
  }

  // Check if Whisper API is available
  void _checkWhisperAvailability() {
    setState(() {
      // Disable Whisper on web platform due to file system limitations
      _useWhisper = !kIsWeb && WhisperService.isConfigured();
    });
    if (!_useWhisper) {
      if (kIsWeb) {
        print('Running on web - using device speech recognition');
      } else if (!WhisperService.isConfigured()) {
        print(
            'Whisper not configured, falling back to device speech recognition');
      }
    }
  }

  // Initialize speech recognition
  void _initSpeech() async {
    _speech = stt.SpeechToText();
    await _speech.initialize();
  }

  // Initialize text-to-speech
  void _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage(_isEnglishMode ? 'en-US' : 'es-ES');
    await _flutterTts.setSpeechRate(0.8);
  }

  // Randomly choose English or Spanish mode
  void _randomizeLanguage() {
    setState(() {
      // Don't randomly switch languages - let user choose
      // _isEnglishMode = Random().nextBool();
      _hasAnswered = false;
      _feedback = '';
    });
    _initTts(); // Reinitialize TTS with current language
  }

  // Helper method to reset all game state
  void _resetGameState() {
    setState(() {
      _hasAnswered = false;
      _feedback = '';
      _recognizedWords = '';
      _isCorrect = false;
      _isListening = false;
    });
    // Stop any ongoing speech recognition
    if (_speech.isListening) {
      _speech.stop();
    }
    // Stop any ongoing recording
    if (_isRecording) {
      _audioRecorder.stop();
      _isRecording = false;
    }
  }

  // Add method to manually switch language
  void _toggleLanguage() {
    setState(() {
      _isEnglishMode = !_isEnglishMode;
    });
    _resetGameState();
    _initTts();
  }

  // Start listening for speech input
  void _startListening() async {
    if (!_isListening && !_hasAnswered) {
      setState(() {
        _isListening = true;
        _recognizedWords = '';
      });

      if (_useWhisper) {
        await _startWhisperRecording();
      } else {
        await _startBuiltInRecording();
      }
    }
  }

  // Stop listening and check answer
  void _stopListening() async {
    if (_isListening) {
      setState(() {
        _isListening = false;
      });

      if (_useWhisper) {
        await _stopWhisperRecording();
      } else {
        await _speech.stop();
        _checkAnswer();
      }
    }
  }

  // Start recording with Whisper
  Future<void> _startWhisperRecording() async {
    try {
      // Check if we're on a supported platform
      if (kIsWeb) {
        print('Whisper recording not supported on web platform');
        // Fall back to built-in speech recognition
        await _startBuiltInRecording();
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        Directory? tempDir;
        try {
          tempDir = await getTemporaryDirectory();
        } catch (e) {
          print('Error getting temporary directory: $e');
          // Fall back to built-in speech recognition
          await _startBuiltInRecording();
          return;
        }

        final String filePath =
            '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            sampleRate: 16000,
            bitRate: 128000,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
        });
      } else {
        print('Audio recording permission not granted');
        // Fall back to built-in speech recognition
        await _startBuiltInRecording();
      }
    } catch (e) {
      print('Error starting recording: $e');
      // Fall back to built-in speech recognition
      setState(() {
        _isListening = true;
        _recognizedWords = '';
      });
      await _startBuiltInRecording();
    }
  }

  // Stop recording and transcribe with Whisper
  Future<void> _stopWhisperRecording() async {
    try {
      if (_isRecording) {
        final String? filePath = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
        });

        if (filePath != null) {
          setState(() {
            _recognizedWords = 'Transcribing...';
          });

          final File audioFile = File(filePath);
          final String languageCode = _isEnglishMode ? 'en' : 'es';

          try {
            final String transcription = await WhisperService.transcribeAudio(
                audioFile,
                language: languageCode);

            setState(() {
              _recognizedWords = transcription.toLowerCase();
              // After updating recognized words, check the answer
              _checkAnswer();
            });

            // Clean up audio file
            if (await audioFile.exists()) {
              await audioFile.delete();
            }
          } catch (e) {
            print('Error transcribing with Whisper: $e');
            setState(() {
              _recognizedWords = 'Transcription failed, please try again';
            });

            // Clean up audio file even on error
            if (await audioFile.exists()) {
              await audioFile.delete();
            }
          }
        } else {
          setState(() {
            _recognizedWords = 'No audio recorded';
          });
        }
      } else {
        // If not recording with Whisper, we're using built-in STT
        _checkAnswer();
      }
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() {
        _recognizedWords = 'Error occurred, please try again';
        _isRecording = false;
      });
    }
  }

  // Fallback to built-in speech recognition
  Future<void> _startBuiltInRecording() async {
    String localeId = _isEnglishMode ? 'en_US' : 'es_ES';
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedWords = result.recognizedWords.toLowerCase();
          if (result.finalResult) {
            _checkAnswer();
          }
        });
      },
      localeId: localeId,
      listenFor: Duration(seconds: 5),
      pauseFor: Duration(seconds: 2),
      partialResults: true,
    );
  }

  // Check if the user's pronunciation is correct
  void _checkAnswer() {
    if (_hasAnswered) return;

    final currentFraction = fractionSet[_currentIndex];
    final expectedAnswer = _isEnglishMode
        ? currentFraction.englishPronunciation.toLowerCase()
        : currentFraction.spanishPronunciation.toLowerCase();

    // Debug output to see exactly what we're comparing
    print('Debug - Recognized: "${_recognizedWords}"');
    print('Debug - Expected: "$expectedAnswer"');
    print('Debug - Recognized length: ${_recognizedWords.length}');
    print('Debug - Expected length: ${expectedAnswer.length}');

    // Enhanced matching logic to handle speech recognition variations
    final isCorrect = _isAnswerCorrect(_recognizedWords, expectedAnswer);

    print('Debug - Match result: $isCorrect');

    setState(() {
      _isCorrect = isCorrect;
      _hasAnswered = true;
      if (isCorrect) {
        _feedback = 'Perfect! Well done!';
      } else {
        _feedback = 'Try again! Correct answer: $expectedAnswer';
      }
    });

    // Speak feedback
    _speakFeedback();

    if (!isCorrect) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _hasAnswered = false;
            _feedback = '';
            _recognizedWords = '';
          });
        }
      });
    }
  }

  // Enhanced answer checking with flexible matching
  bool _isAnswerCorrect(String recognized, String expected) {
    if (recognized.isEmpty) return false;

    print('Debug - Raw comparison: "$recognized" vs "$expected"');

    // Clean and normalize both strings
    String cleanRecognized = _cleanAndNormalize(recognized);
    String cleanExpected = _cleanAndNormalize(expected);

    print('Debug - After cleaning: "$cleanRecognized" vs "$cleanExpected"');

    // Special case: if user says just "1" or "one" for fractions like "1/2"
    if ((recognized == "1" || cleanRecognized == "one") &&
        cleanExpected.startsWith("one ")) {
      print('Debug - Special case: User said just the numerator');
      return true; // Accept saying just the numerator for simple fractions
    }

    // Exact match after cleaning
    if (cleanRecognized == cleanExpected) {
      print('Debug - Exact match found');
      return true;
    }

    // Check if recognized text contains expected text or vice versa
    if (cleanRecognized.contains(cleanExpected) ||
        cleanExpected.contains(cleanRecognized)) {
      print('Debug - Contains match found');
      return true;
    }

    // Check word-by-word similarity for partial matches
    List<String> recognizedWords =
        cleanRecognized.split(' ').where((w) => w.isNotEmpty).toList();
    List<String> expectedWords =
        cleanExpected.split(' ').where((w) => w.isNotEmpty).toList();

    print('Debug - Word comparison: $recognizedWords vs $expectedWords');

    // If both are single words, check for close matches
    if (recognizedWords.length == 1 && expectedWords.length == 1) {
      return recognizedWords[0] == expectedWords[0];
    }

    // For multi-word phrases, check if recognized words match the start of expected
    if (recognizedWords.length <= expectedWords.length) {
      bool allMatch = true;
      for (int i = 0; i < recognizedWords.length; i++) {
        if (recognizedWords[i] != expectedWords[i]) {
          allMatch = false;
          break;
        }
      }
      if (allMatch) {
        double completeness = recognizedWords.length / expectedWords.length;
        print(
            'Debug - Partial match: ${(completeness * 100).toStringAsFixed(1)}% complete');
        return completeness >= 0.6; // Require at least 60% for acceptance
      }
    }

    print('Debug - No match found');
    return false;
  }

  // Clean and normalize text in one step
  String _cleanAndNormalize(String text) {
    String cleaned = text.toLowerCase().trim();

    // Apply fraction-specific normalizations FIRST (before removing punctuation)
    cleaned = cleaned
        // Handle numerical fraction inputs first (before punctuation removal)
        .replaceAll(RegExp(r'\b1/2\b'), 'one half')
        .replaceAll(RegExp(r'\b1/4\b'), 'one fourth')
        .replaceAll(RegExp(r'\b3/4\b'), 'three fourths')
        .replaceAll(RegExp(r'\b2/3\b'), 'two thirds')
        .replaceAll(RegExp(r'\b5/8\b'), 'five eighths');

    // Now remove punctuation and normalize whitespace
    cleaned = cleaned
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .replaceAll(RegExp(r'\s+'), ' '); // Normalize whitespace

    // Handle remaining normalizations
    cleaned = cleaned
        // Handle single digit to word (only if not already part of a fraction phrase)
        .replaceAll(RegExp(r'\b1\b(?!\s+half)(?!\s+fourth)'), 'one')
        .replaceAll(RegExp(r'\b2\b'), 'two')
        .replaceAll(RegExp(r'\b3\b'), 'three')
        .replaceAll(RegExp(r'\b4\b'), 'four')
        .replaceAll(RegExp(r'\b5\b'), 'five')
        .replaceAll(RegExp(r'\b8\b'), 'eight')
        // Handle standalone "half" and "quarter" only if not already preceded by a number word
        .replaceAll(RegExp(r'(?<!one\s)\bhalf\b'), 'one half')
        .replaceAll(RegExp(r'(?<!one\s)\bquarter\b'), 'one fourth');

    return cleaned.trim();
  }

  // Speak the feedback and correct answer if needed
  void _speakFeedback() async {
    if (_isCorrect) {
      await _flutterTts.speak('Well done!');
    } else {
      final currentFraction = fractionSet[_currentIndex];
      final correctAnswer = _isEnglishMode
          ? currentFraction.englishPronunciation
          : currentFraction.spanishPronunciation;
      await _flutterTts.speak(correctAnswer);
    }
  }

  // Move to next fraction
  void _nextFraction() {
    if (_currentIndex < fractionSet.length - 1) {
      // Stop any ongoing speech recognition immediately
      if (_speech.isListening) {
        _speech.stop();
      }
      if (_isRecording) {
        _audioRecorder.stop();
      }

      setState(() {
        _currentIndex++;
        // Reset all game state immediately in the same setState
        _hasAnswered = false;
        _feedback = '';
        _recognizedWords = '';
        _isCorrect = false;
        _isListening = false;
        _isRecording = false;
      });
      _initTts(); // Reinitialize TTS with current language
    }
  }

  // Move to previous fraction
  void _previousFraction() {
    if (_currentIndex > 0) {
      // Stop any ongoing speech recognition immediately
      if (_speech.isListening) {
        _speech.stop();
      }
      if (_isRecording) {
        _audioRecorder.stop();
      }

      setState(() {
        _currentIndex--;
        // Reset all game state immediately in the same setState
        _hasAnswered = false;
        _feedback = '';
        _recognizedWords = '';
        _isCorrect = false;
        _isListening = false;
        _isRecording = false;
      });
      _initTts(); // Reinitialize TTS with current language
    }
  }

  // Replay current fraction
  void _replayFraction() {
    _resetGameState();
    _initTts(); // Reinitialize TTS with current language
  }

  // Reset current game
  void _resetGame() {
    setState(() {
      _currentIndex = 0;
      _recognizedWords = '';
    });
    _randomizeLanguage();
  }

  // Show temporary popup for instructions
  void showTemporaryPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: SizedBox(
            height: 100,
            child: Center(
              child: Text(message,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
            ),
          ),
        );
      },
    );
  }

  // Show chatbot popup for hints
  void showChatbotPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                width: double.maxFinite,
                height: 500,
                child: Column(
                  children: [
                    const Text("Math Helper",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _chatHistory.length,
                        itemBuilder: (context, index) {
                          final entry = _chatHistory[index];
                          final isUser = entry['role'] == 'user';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                entry['text']!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _chatController,
                      decoration: const InputDecoration(
                        hintText: "Ask for a hint...",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final userMessage = _chatController.text;
                        if (userMessage.trim().isEmpty) return;

                        _chatController.clear();

                        setState(() {
                          _chatHistory
                              .add({"role": "user", "text": userMessage});
                        });

                        final gameContext = '''
Game Title: Pronunciation Practice
Current Fraction: ${fractionSet[_currentIndex].fractionDisplay}
Language Mode: ${_isEnglishMode ? 'English' : 'Spanish'}
Current Task: Practice pronouncing fractions in different languages.
Instructions: Look at the fraction and say it out loud in the requested language.
''';
                        final aiReply = await GeminiChatService.getHint(
                            userMessage, gameContext);

                        setStatePopup(() {
                          _chatHistory.add({"role": "model", "text": aiReply});
                        });
                      },
                      child: const Text("Get Hint"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFraction = fractionSet[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Speak the Fraction',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
                _isEnglishMode ? Icons.translate : Icons.translate_outlined),
            onPressed: _toggleLanguage,
            tooltip: _isEnglishMode ? 'Switch to Spanish' : 'Switch to English',
          ),
          IconButton(
            icon: const Icon(Icons.info, size: 30),
            onPressed: () => showTemporaryPopup(
                "Look at the fraction and say it out loud in the requested language!"),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Language mode indicator
          Container(
            child: Text(
              _isEnglishMode ? 'in English!' : 'en español!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),

          // Fraction display
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: randomBoxColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  currentFraction.numerator,
                  style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  height: 5,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 5),
                Text(
                  currentFraction.denominator,
                  style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          // Speech recognition status and result
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (_isListening)
                  const Text(
                    'Listening...',
                    style: TextStyle(fontSize: 20, color: Color(0xFF8F87F1)),
                  ),
                if (_hasAnswered)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_hasAnswered) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Expected:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '"${_isEnglishMode ? fractionSet[_currentIndex].englishPronunciation : fractionSet[_currentIndex].spanishPronunciation}"',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                if (_hasAnswered)
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _feedback,
                          style: TextStyle(
                            fontSize: 20,
                            color: _isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Microphone button
          GestureDetector(
            onTap: () {
              if (_isListening) {
                _stopListening();
              } else if (!_hasAnswered) {
                _startListening();
              }
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _hasAnswered
                    ? Colors.grey
                    : (_isListening ? Colors.red : Color(0xFF8F87F1)),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),

          Column(
            children: [
              Text(
                _hasAnswered
                    ? 'Answer recorded'
                    : (_isListening ? 'Tap to stop' : 'Tap to speak'),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (!_hasAnswered)
                Text(
                  'Speak clearly and at normal pace',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
            ],
          ),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentIndex > 0)
                ElevatedButton(
                  onPressed: _previousFraction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F87F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Previous'),
                ),
              if (_currentIndex > 0) const SizedBox(width: 16),
              // Replay button
              ElevatedButton.icon(
                onPressed: _replayFraction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8F87F1),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.replay, size: 20),
                label: const Text('Replay'),
              ),
              if (_currentIndex < fractionSet.length - 1)
                const SizedBox(width: 16),
              if (_currentIndex < fractionSet.length - 1)
                ElevatedButton(
                  onPressed: _nextFraction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F87F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Next'),
                ),
            ],
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    _audioRecorder.dispose();
    _chatController.dispose();
    super.dispose();
  }
}
