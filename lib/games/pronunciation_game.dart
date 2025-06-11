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
  int score = 0;
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
    _randomizeLanguage();
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
      _isEnglishMode = Random().nextBool();
      _hasAnswered = false;
      _feedback = '';
    });
    _initTts(); // Reinitialize TTS with new language
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
            });

            // Clean up audio file
            if (await audioFile.exists()) {
              await audioFile.delete();
            }

            _checkAnswer();
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
        });
      },
      localeId: localeId,
      listenFor: Duration(seconds: 5), // Give more time to speak
      pauseFor: Duration(seconds: 2), // Wait longer before stopping
      partialResults: true, // Show partial results while speaking
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
        score += 10;
        _feedback = 'Well done!';
      } else {
        score -= 5;
        _feedback = 'Try again! Correct answer: $expectedAnswer';
      }
    });

    // Speak feedback
    _speakFeedback();
  }

  // Enhanced answer checking with flexible matching
  bool _isAnswerCorrect(String recognized, String expected) {
    if (recognized.isEmpty) return false;

    print('Debug - Raw comparison: "$recognized" vs "$expected"');

    // Remove any invisible/non-printing characters and normalize spaces
    String basicRecognized = recognized
        .replaceAll(RegExp(r'[^\x20-\x7E\u00A1-\uFFFF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();
    String basicExpected = expected
        .replaceAll(RegExp(r'[^\x20-\x7E\u00A1-\uFFFF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();

    print(
        'Debug - After invisible char removal: "$basicRecognized" vs "$basicExpected"');

    // First try direct comparison (case insensitive)
    if (basicRecognized == basicExpected) {
      print('Debug - Direct match found after cleaning');
      return true;
    }

    // Clean and normalize both strings
    String cleanRecognized = _cleanText(recognized);
    String cleanExpected = _cleanText(expected);

    print('Debug - After cleaning: "$cleanRecognized" vs "$cleanExpected"');

    // Exact match after cleaning
    if (cleanRecognized == cleanExpected) {
      print('Debug - Clean match found');
      return true;
    }

    // Check if expected answer is contained in recognized text
    if (cleanRecognized.contains(cleanExpected)) {
      print('Debug - Contains match found');
      return true;
    }

    // Handle common number-to-word variations
    String normalizedRecognized = _normalizeNumbers(cleanRecognized);
    String normalizedExpected = _normalizeNumbers(cleanExpected);

    print(
        'Debug - After normalization: "$normalizedRecognized" vs "$normalizedExpected"');

    if (normalizedRecognized == normalizedExpected) {
      print('Debug - Normalized match found');
      return true;
    }

    if (normalizedRecognized.contains(normalizedExpected)) {
      print('Debug - Normalized contains match found');
      return true;
    }

    // Check similarity for minor differences (allow some flexibility)
    bool similarMatch = _isSimilar(normalizedRecognized, normalizedExpected);
    print('Debug - Similarity match: $similarMatch');

    return similarMatch;
  }

  // Clean text by removing punctuation, extra spaces, and converting to lowercase
  String _cleanText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();
  }

  // Convert common number variations to words
  String _normalizeNumbers(String text) {
    return text
        .replaceAll('1', 'one')
        .replaceAll('2', 'two')
        .replaceAll('3', 'three')
        .replaceAll('4', 'four')
        .replaceAll('5', 'five')
        .replaceAll('6', 'six')
        .replaceAll('7', 'seven')
        .replaceAll('8', 'eight')
        .replaceAll('9', 'nine')
        .replaceAll('1st', 'first')
        .replaceAll('2nd', 'second')
        .replaceAll('3rd', 'third')
        .replaceAll('4th', 'fourth')
        .replaceAll('5th', 'fifth')
        .replaceAll('6th', 'sixth')
        .replaceAll('7th', 'seventh')
        .replaceAll('8th', 'eighth')
        .replaceAll('9th', 'ninth')
        .replaceAll('-', ' ') // Handle hyphenated fractions
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // Check if two strings are similar (allowing for minor differences)
  bool _isSimilar(String str1, String str2) {
    // Split into words and check if key words match
    List<String> words1 = str1.split(' ').where((w) => w.isNotEmpty).toList();
    List<String> words2 = str2.split(' ').where((w) => w.isNotEmpty).toList();

    print('Debug - Similarity check: words1=$words1, words2=$words2');

    // Special handling for partial matches (e.g., "one" vs "one half")
    if (words1.length < words2.length) {
      // Check if all recognized words are correct and in order
      bool allCorrect = true;
      for (int i = 0; i < words1.length; i++) {
        if (i >= words2.length || words1[i] != words2[i]) {
          allCorrect = false;
          break;
        }
      }

      if (allCorrect) {
        print(
            'Debug - Partial match found: recognized words are correct start of expected phrase');
        // Accept partial matches that are at least 50% of the expected phrase
        double completeness = words1.length / words2.length;
        print(
            'Debug - Completeness: ${(completeness * 100).toStringAsFixed(1)}%');
        return completeness >= 0.5; // Accept if at least 50% complete
      }
    }

    // If both have same number of words and are short phrases, be more lenient
    if (words1.length <= 2 && words2.length <= 2) {
      int exactMatches = 0;
      for (String expectedWord in words2) {
        for (String recognizedWord in words1) {
          if (recognizedWord == expectedWord) {
            exactMatches++;
            break;
          }
        }
      }
      print(
          'Debug - Short phrase exact matches: $exactMatches/${words2.length}');

      // For short phrases, accept if we have at least 50% match
      double matchPercentage = exactMatches / words2.length;
      print(
          'Debug - Match percentage: ${(matchPercentage * 100).toStringAsFixed(1)}%');
      return matchPercentage >=
          0.5; // More lenient: 50% match for short phrases
    }

    // For longer phrases, use the original logic
    int matchCount = 0;
    for (String expectedWord in words2) {
      for (String recognizedWord in words1) {
        if (recognizedWord == expectedWord ||
            recognizedWord.contains(expectedWord) ||
            expectedWord.contains(recognizedWord)) {
          matchCount++;
          break;
        }
      }
    }

    print('Debug - Match count: $matchCount/${words2.length}');
    // Consider it correct if most expected words are found
    return matchCount >=
        words2.length * 0.5; // More lenient: 50% match threshold
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
      setState(() {
        _currentIndex++;
        _recognizedWords = '';
      });
      _randomizeLanguage();
    }
  }

  // Move to previous fraction
  void _previousFraction() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _recognizedWords = '';
      });
      _randomizeLanguage();
    }
  }

  // Reset current game
  void _resetGame() {
    setState(() {
      _currentIndex = 0;
      score = 0;
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
        title: const Text(
          'Pronunciation Practice',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, size: 30),
            onPressed: () => showTemporaryPopup(
                "Look at the fraction and say it out loud in the requested language!"),
          ),
          IconButton(
            icon: const Icon(Icons.smart_toy, size: 30),
            onPressed: showChatbotPopup,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Score display
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Score: ", style: TextStyle(fontSize: 25)),
            TextSpan(
                text: "$score",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ))
          ])),

          // Language mode indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _isEnglishMode
                  ? Colors.blue.shade100
                  : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _isEnglishMode ? 'Say this in English' : 'Di esto en español',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // Fraction display
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  currentFraction.numerator,
                  style: const TextStyle(
                      fontSize: 80, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 5,
                  width: 100,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                Text(
                  currentFraction.denominator,
                  style: const TextStyle(
                      fontSize: 80, fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                if (_recognizedWords.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        'You said: "$_recognizedWords"',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      if (_hasAnswered)
                        Text(
                          'Expected: "${_isEnglishMode ? fractionSet[_currentIndex].englishPronunciation : fractionSet[_currentIndex].spanishPronunciation}"',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                if (_hasAnswered)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isCorrect ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _feedback,
                            style: TextStyle(
                              fontSize: 18,
                              color: _isCorrect ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Microphone button
          GestureDetector(
            onTapDown: (_) => _startListening(),
            onTapUp: (_) => _stopListening(),
            onTapCancel: () => _stopListening(),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _isListening ? Colors.red : Colors.blue,
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
                Icons.mic,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),

          Column(
            children: [
              Text(
                'Hold to speak',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Speak slowly and clearly',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (_useWhisper)
                Text(
                  'Using Whisper AI',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                )
              else
                Text(
                  'Using device recognition',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
            ],
          ),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 35),
                onPressed: () => _currentIndex > 0
                    ? _previousFraction()
                    : Navigator.pop(context),
              ),
              IconButton(
                icon: const Icon(Icons.replay, size: 35),
                onPressed: _resetGame,
              ),
              if (_hasAnswered)
                ElevatedButton(
                  onPressed: _nextFraction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(95, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 18)),
                ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 35),
                onPressed: () {
                  if (_currentIndex < fractionSet.length - 1) {
                    _nextFraction();
                  }
                },
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
