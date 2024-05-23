import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildTextPage(
            'What are fractions?',
            'A fraction is part of a whole. It\'s less than 1 whole thing, but more than 0. We use fractions all the time in real life. Have you ever eaten half of a chocolate? Or noticed a quarter? Both of these are fractions of the whole amount—a whole chocolate, or a whole dollar.\n\nFractions look a little like division expressions, but they aren\'t problems to be solved. They are a way of expressing an amount. Like numbers, fractions tell you how much you have of something.',
          ),
          _buildImagePage(
            'assets/learn/pizza1.png',
            'Let\'s imagine that you have one pizza divided into 8 slices.',
          ),
          _buildImagePage(
            'assets/learn/pizza2.png',
            'Say that you take 1 of the 8 slices.',
          ),
          _buildImagePage(
            'assets/learn/pizza3.png',
            'You could say that you took 1/8 of the pizza. 1/8 is a fraction.',
          ),
          _buildImagePage(
            'assets/learn/pizza4.png',
            'We write it like that because the pizza has 8 slices...and you\'re taking 1.',
          ),
          _buildImagePage(
            'assets/learn/pizza5.png',
            'What if you take 2 slices?'
          ),
          _buildImagePage(
            'assets/learn/pizza6.png',
            'Now you\'re taking 2/8 of the pizza.\nThe bottom number, 8, stayed the same, since the pizza is still divided into the same number of slices.\nThe top number changed, since we\'re talking about 2 slices now.',
          ),
          _buildImagePage(
            'assets/learn/pizza7.png',
            'We could also say that 6/8 slices were left. There\'s less than 1 pizza, but more than 0 pizzas. That\'s why we use a fraction.',
          ),
          _buildTextPage(
            'Writing fractions',
            'Every fraction has two parts: a top number and a bottom number. In math terms, these are called the numerator and the denominator. Don\'t worry too much about remembering those names. As long as you remember what each number means, you can understand any fraction.',
          ),
          _buildImagePage(
            'assets/learn/num_deno.png',
            'The top number, or numerator, refers to a certain number of those parts. It lets us know how much we\'re talking about. And the bottom number, or denominator, is the number of parts a whole is divided into.',
          ),
          _buildTextPage(
            'Reading fractions',
            'When we read or talk about fractions, we use special numbers called ordinal numbers. A good way to remember this is that many of them are the same numbers you use when you\'re putting things in order: third, fourth, fifth, and so on.\n\nYou might know some of these numbers already. For example, when you share half a chocolate with your friend, you both are eating 1/2 of the chocolate.',
          ),
          _buildImagePage(
              'assets/learn/reading.png',
              'If you had a pizza with eight slices, each slice would be 1/8 of the pizza. You\'d read that like this: one-eighth.',
          ),
          _buildImagePage(
            'assets/learn/ordinal.png',
            'Here are some of the most commonly used fractions. \nA good rule to remember is that most ordinal numbers end in "th." \nSo, 1/20 is one-twentieth. 1/35 is one-thirty-fifth.',
          ),
          _buildTextPage(
            'Mixed numbers',
            'Sometimes you might see a fraction next to a whole number. We call this a mixed number.',
          ),
          _buildImagePage(
            'assets/learn/mixed.png',
            'What if you pour 1 whole cup of tea, then fill only 2/3 of another cup? You\'d read 1 2/3 like this: one and two-thirds. Remember, the whole number is always first.',
          ),
        ],
      ),
    );
  }

  Widget _buildTextPage(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
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
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
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
