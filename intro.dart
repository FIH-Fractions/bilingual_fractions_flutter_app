import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MaterialApp(home: IntroPage()));
}

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool isSpanish = false;
  String currentText = '';
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    flutterTts.setLanguage('en-US');
    flutterTts.setPitch(1.0);
    flutterTts.setSpeechRate(0.5);
  }

  void _speak() async {
    if (currentText.isNotEmpty) {
      await flutterTts.speak(currentText);
    }
  }

  void _updateText(String text) {
    setState(() {
      currentText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: _speak,
          ),
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () {
              setState(() {
                isSpanish = !isSpanish;
                // Update the current text for speech when language changes
                _updateText(currentText); // Add implementation to handle language switch
                });
            },
          ),
        ],
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildTextPage(
            isSpanish ? '¿Qué son las fracciones?' : 'What are fractions?',
            isSpanish ? 'Una fracción es parte de un todo. Es menos de 1 cosa completa, pero más que 0. Usamos fracciones todo el tiempo en la vida real. ¿Has comido la mitad de un chocolate? ¿O notado un cuarto? Ambos son fracciones del total—un chocolate completo, o un dólar completo.\n\nLas fracciones se parecen un poco a las expresiones de división, pero no son problemas a resolver. Son una forma de expresar una cantidad. Como los números, las fracciones te dicen cuánto tienes de algo.' :
            'A fraction is part of a whole. It\'s less than 1 whole thing, but more than 0. We use fractions all the time in real life. Have you ever eaten half of a chocolate? Or noticed a quarter? Both of these are fractions of the whole amount—a whole chocolate, or a whole dollar.\n\nFractions look a little like division expressions, but they aren\'t problems to be solved. They are a way of expressing an amount. Like numbers, fractions tell you how much you have of something.',
          ),
          _buildImagePage(
            'assets/learn/pizza1.png',
            isSpanish ? 'Imagina que tienes una pizza dividida en 8 porciones.' : 'Let\'s imagine that you have one pizza divided into 8 slices.',
          ),
          _buildImagePage(
            'assets/learn/pizza2.png',
            isSpanish ? 'Supongamos que tomas 1 de las 8 porciones.' : 'Say that you take 1 of the 8 slices.',
          ),
          _buildImagePage(
            'assets/learn/pizza3.png',
            isSpanish ? 'Podrías decir que tomaste 1/8 de la pizza. 1/8 es una fracción.' : 'You could say that you took 1/8 of the pizza. 1/8 is a fraction.',
          ),
          _buildImagePage(
            'assets/learn/pizza4.png',
            isSpanish ? 'Lo escribimos así porque la pizza tiene 8 porciones... y estás tomando 1.' : 'We write it like that because the pizza has 8 slices...and you\'re taking 1.',
          ),
          _buildImagePage(
              'assets/learn/pizza5.png',
              isSpanish ? '¿Qué pasa si tomas 2 porciones?' : 'What if you take 2 slices?'
          ),
          _buildImagePage(
            'assets/learn/pizza6.png',
            isSpanish ? 'Ahora estás tomando 2/8 de la pizza.\nEl número inferior, 8, se mantiene igual, ya que la pizza todavía está dividida en el mismo número de porciones.\nEl número superior cambió, ya que estamos hablando de 2 porciones ahora.' :
            'Now you\'re taking 2/8 of the pizza.\nThe bottom number, 8, stayed the same, since the pizza is still divided into the same number of slices.\nThe top number changed, since we\'re talking about 2 slices now.',
          ),
          _buildImagePage(
            'assets/learn/pizza7.png',
            isSpanish ? 'También podríamos decir que quedaron 6/8 porciones. Hay menos de 1 pizza, pero más de 0 pizzas. Por eso usamos una fracción.' :
            'We could also say that 6/8 slices were left. There\'s less than 1 pizza, but more than 0 pizzas. That\'s why we use a fraction.',
          ),
          _buildTextPage(
            isSpanish ? 'Escribiendo fracciones' : 'Writing fractions',
            isSpanish ? 'Cada fracción tiene dos partes: un número superior y un número inferior. En términos matemáticos, estos se llaman numerador y denominador. No te preocupes demasiado por recordar esos nombres. Mientras recuerdes lo que significa cada número, puedes entender cualquier fracción.' :
            'Every fraction has two parts: a top number and a bottom number. In math terms, these are called the numerator and the denominator. Don\'t worry too much about remembering those names. As long as you remember what each number means, you can understand any fraction.',
          ),
          _buildImagePage(
            'assets/learn/num_deno.png',
            isSpanish ? 'El número superior, o numerador, se refiere a cierto número de esas partes. Nos deja saber cuánto estamos hablando. Y el número inferior, o denominador, es el número de partes en que se divide un todo.' :
            'The top number, or numerator, refers to a certain number of those parts. It lets us know how much we\'re talking about. And the bottom number, or denominator, is the number of parts a whole is divided into.',
          ),
          _buildTextPage(
            isSpanish ? 'Leyendo fracciones' : 'Reading fractions',
            isSpanish ? 'Cuando leemos o hablamos de fracciones, usamos números especiales llamados números ordinales. Una buena manera de recordar esto es que muchos de ellos son los mismos números que usas cuando estás ordenando cosas: tercero, cuarto, quinto, etc.\n\nTal vez ya conozcas algunos de estos números. Por ejemplo, cuando compartes la mitad de un chocolate con tu amigo, ambos están comiendo 1/2 del chocolate.' :
            'When we read or talk about fractions, we use special numbers called ordinal numbers. A good way to remember this is that many of them are the same numbers you use when you\'re putting things in order: third, fourth, fifth, and so on.\n\nYou might know some of these numbers already. For example, when you share half a chocolate with your friend, you both are eating 1/2 of the chocolate.',
          ),
          _buildImagePage(
            'assets/learn/reading.png',
            isSpanish ? 'Si tuvieras una pizza con ocho porciones, cada porción sería 1/8 de la pizza. Leerías eso así: un octavo.' :
            'If you had a pizza with eight slices, each slice would be 1/8 of the pizza. You\'d read that like this: one-eighth.',
          ),
          _buildImagePage(
            'assets/learn/ordinal.png',
            isSpanish ? 'Aquí están algunas de las fracciones más comúnmente usadas. \nUna buena regla para recordar es que la mayoría de los números ordinales terminan en "th." \nAsí, 1/20 es one-twentieth. 1/35 es one-thirty-fifth.' :
            'Here are some of the most commonly used fractions. \nA good rule to remember is that most ordinal numbers end in "th." \nSo, 1/20 is one-twentieth. 1/35 is one-thirty-fifth.',
          ),
          _buildTextPage(
            isSpanish ? 'Números mixtos' : 'Mixed numbers',
            isSpanish ? 'A veces podrías ver una fracción junto a un número entero. A esto lo llamamos un número mixto.' :
            'Sometimes you might see a fraction next to a whole number. We call this a mixed number.',
          ),
          _buildImagePage(
            'assets/learn/mixed.png',
            isSpanish ? '¿Qué pasa si viertes 1 taza entera de té, luego llenas solo 2/3 de otra taza? Lo leerías así: uno y dos tercios. Recuerda, el número entero siempre va primero.' :
            'What if you pour 1 whole cup of tea, then fill only 2/3 of another cup? You\'d read 1 2/3 like this: one and two-thirds. Remember, the whole number is always first.',
          ),
        ],
      ),
    );
  }

  Widget _buildTextPage(String title, String description) {
    _updateText(description);  // Update the text for TTS whenever a text page is displayed
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _stepImagePage(String imagePath, String description) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 350,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePage(String imagePath, String description) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 530,
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain
                )
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}