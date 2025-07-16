import 'package:bilingual_fractions_flutter_app/games/fruits_basket_game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'matching_game.dart';
import 'eating_fruits_game.dart';
import 'exercise.dart';
import 'pronunciation_game.dart';

class GameInfo {
  final String titleEn;
  final String titleEs;
  final String imagePath;
  final Color color;
  final Widget page;
  final String descriptionEn;
  final String descriptionEs;

  GameInfo({
    required this.titleEn,
    required this.titleEs,
    required this.imagePath,
    required this.color,
    required this.page,
    required this.descriptionEn,
    required this.descriptionEs,
  });
}

class Games extends StatefulWidget {
  const Games({Key? key}) : super(key: key);

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    final List<GameInfo> games = [
      GameInfo(
        titleEn: 'Write Fractions',
        titleEs: 'Escribir Fracciones',
        imagePath: 'game_icons/write_fractions.jpg',
        color: const Color(0xFF4AA3B6),
        page: const FractionWritingGame(),
        descriptionEn:
            'Learn to write fractions by practicing with visual examples',
        descriptionEs:
            'Aprende a escribir fracciones practicando con ejemplos visuales',
      ),
      GameInfo(
        titleEn: 'Speak Fractions',
        titleEs: 'Pronunciar Fracciones',
        imagePath: 'game_icons/speak_fractions.jpg',
        color: const Color(0xFFD76D23),
        page: PronunciationGame(),
        descriptionEn: 'Practice pronouncing fractions in English and Spanish',
        descriptionEs:
            'Practica la pronunciación de fracciones en inglés y español',
      ),
      GameInfo(
        titleEn: 'Match Fractions',
        titleEs: 'Emparejar Fracciones',
        imagePath: 'game_icons/match_fractions.jpg',
        color: const Color(0xFF649889),
        page: const MatchingGame(),
        descriptionEn: 'Match fraction names with their visual representations',
        descriptionEs:
            'Empareja los nombres de fracciones con sus representaciones visuales',
      ),
      GameInfo(
        titleEn: 'Eat The Fruits',
        titleEs: 'Comer las Frutas',
        imagePath: 'game_icons/eat_fruits.jpg',
        color: const Color(0xFF545FA7),
        page: EatingFruitsGame(),
        descriptionEn: 'Click on fruits to eat the correct fraction amounts',
        descriptionEs:
            'Haz clic en las frutas para comer las cantidades de fracciones correctas',
      ),
      GameInfo(
        titleEn: 'Fruits Basket',
        titleEs: 'Canasta de Frutas',
        imagePath: 'game_icons/fruits_basket.jpg',
        color: const Color(0xFF6C8D28),
        page: FruitsBasketGame(),
        descriptionEn: 'Create balanced fruit baskets using fraction concepts',
        descriptionEs:
            'Crea canastas de frutas equilibradas usando conceptos de fracciones',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFA),
        elevation: 0,
        title: Text(
          isEnglish ? 'Games' : 'Juegos',
          style: GoogleFonts.comicNeue(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.translate_rounded,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  isEnglish = !isEnglish;
                });
              },
              tooltip: isEnglish ? 'Cambiar a español' : 'Switch to English',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEnglish
                    ? 'Choose a game to practice fractions!'
                    : '¡Elige un juego para practicar fracciones!',
                style: GoogleFonts.comicNeue(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                        0.65, // Much taller cards for 3:4 portrait images
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return GameCard(
                      gameInfo: games[index],
                      isEnglish: isEnglish,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 4;
    if (screenWidth > 800) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }
}

class GameCard extends StatefulWidget {
  final GameInfo gameInfo;
  final bool isEnglish;

  const GameCard({
    Key? key,
    required this.gameInfo,
    required this.isEnglish,
  }) : super(key: key);

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.gameInfo.page),
          );
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                      blurRadius: _isHovered ? 20 : 12,
                      offset: Offset(0, _isHovered ? 8 : 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // Large prominent image section - Fixed aspect ratio
                      Expanded(
                        flex:
                            4, // Takes up 4/5 of the card (more space for image)
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              widget.gameInfo.imagePath,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover, // Fill the container perfectly
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        widget.gameInfo.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.games,
                                    color: widget.gameInfo.color,
                                    size: 60,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Compact content section - No title, just description and button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: widget.gameInfo.color,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.isEnglish
                                  ? widget.gameInfo.descriptionEn
                                  : widget.gameInfo.descriptionEs,
                              style: GoogleFonts.comicNeue(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.95),
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.isEnglish ? 'Play Now' : 'Jugar Ahora',
                                style: GoogleFonts.comicNeue(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: widget.gameInfo.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
