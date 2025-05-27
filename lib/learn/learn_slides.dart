import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.translate_rounded,
              size: 35,
              color: Colors.black,
            ),
            onPressed: () async {
              setState(() => isEnglish = !isEnglish);
              await FirebaseFirestore.instance
                  .collection('analytics')
                  .doc('learn_section_translate')
                  .set(
                    {'count': FieldValue.increment(1)},
                    SetOptions(merge: true),
                  );
            },
          ),
        ],
      ),
      body: Column(
      children: [
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
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (slide.imagePath != null)
                      SizedBox(
                        width: 530,
                        height: 350,
                        child: Image.asset(slide.imagePath!, fit: BoxFit.contain),
                      ),
                    if (slide.imagePath != null) const SizedBox(height: 20),
                    if (slide.titleEn.isNotEmpty)
                      Text(
                        isEnglish ? slide.titleEn : slide.titleEs,
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      isEnglish ? slide.descEn : slide.descEs,
                      style: const TextStyle(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
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
      ],),
    );
  }
}
