class LearnSlide {
  final String? imagePath;
  final String titleEn;
  final String descEn;
  final String titleEs;
  final String descEs;

  LearnSlide({
    this.imagePath,
    required this.titleEn,
    required this.descEn,
    required this.titleEs,
    required this.descEs,
  });
}

final List<LearnSlide> learnSlides = [
  LearnSlide(
    titleEn: "What are fractions?",
    descEn: "A fraction is part of a whole. It's less than 1 whole thing, but more than 0. We use fractions all the time in real life. Have you ever eaten half of a chocolate? Or noticed a quarter? Both of these are fractions of the whole amount—a whole chocolate, or a whole dollar.\n\nFractions look a little like division expressions, but they aren't problems to be solved. They are a way of expressing an amount. Like numbers, fractions tell you how much you have of something.",
    titleEs: "¿Qué son las fracciones?",
    descEs: "Una fracción es una parte de un todo. Es menos que una unidad completa, pero más que cero. Usamos fracciones todo el tiempo en la vida real. ¿Alguna vez has comido la mitad de un chocolate? ¿O notado un cuarto? Ambos son fracciones de una cantidad total: un chocolate entero o un dólar entero.\n\nLas fracciones se parecen un poco a expresiones de división, pero no son problemas para resolver. Son una forma de expresar una cantidad. Como los números, las fracciones indican cuánto tienes de algo.",
  ),
  LearnSlide(
    imagePath: "assets/learn/pizza1.png",
    titleEn: "",
    descEn: "Let's imagine that you have one pizza divided into 8 slices.",
    titleEs: "",
    descEs: "Imaginemos que tienes una pizza dividida en 8 porciones.",
  ),
  LearnSlide(
    imagePath: "assets/learn/pizza2.png",
    titleEn: "",
    descEn: "Say that you take 1 of the 8 slices.",
    titleEs: "",
    descEs: "Digamos que tomas 1 de las 8 porciones.",
  ),
  LearnSlide(
    imagePath: "assets/learn/pizza3.png",
    titleEn: "",
    descEn: "You could say that you took 1/8 of the pizza. 1/8 is a fraction.",
    titleEs: "",
    descEs: "Podrías decir que tomaste 1/8 de la pizza. 1/8 es una fracción.",
  ),
  LearnSlide(
    imagePath: "assets/learn/pizza4.png",
    titleEn: "",
    descEn: "We write it like that because the pizza has 8 slices...and you're taking 1.",
    titleEs: "",
    descEs: "Lo escribimos así porque la pizza tiene 8 porciones... y estás tomando 1.",
  ),
  LearnSlide(
    imagePath: "assets/learn/pizza5.png",
    titleEn: "",
    descEn: "What if you take 2 slices?",
    titleEs: "",
    descEs: "¿Y si tomas 2 porciones?",
  ),
  LearnSlide(
    imagePath: "assets/learn/pizza6.png",
    titleEn: "",
    descEn: "Now you're taking 2/8 of the pizza.\nThe bottom number, 8, stayed the same, since the pizza is still divided into the same number of slices.\nThe top number changed, since we're talking about 2 slices now.",
    titleEs: "",
    descEs: "Ahora estás tomando 2/8 de la pizza.\nEl número inferior, 8, sigue igual, ya que la pizza aún está dividida en 8 porciones.\nEl número superior cambió, porque ahora hablamos de 2 porciones.",
  ),    
  LearnSlide(
    imagePath: "assets/learn/pizza7.png",
    titleEn: "",
    descEn: "We could also say that 6/8 slices were left. There's less than 1 pizza, but more than 0 pizzas. That's why we use a fraction.",
    titleEs: "",
    descEs: "También podríamos decir que quedaron 6/8 porciones. Es menos que una pizza, pero más que cero pizzas. Por eso usamos una fracción.",
  ),
  LearnSlide(
    titleEn: "Writing fractions",
    descEn: "Every fraction has two parts: a top number and a bottom number. In math terms, these are called the numerator and the denominator. Don't worry too much about remembering those names. As long as you remember what each number means, you can understand any fraction.",
    titleEs: "Escribiendo fracciones",
    descEs: "Cada fracción tiene dos partes: un número superior y un número inferior. En términos matemáticos, se llaman numerador y denominador. No te preocupes mucho por recordar esos nombres. Mientras recuerdes lo que significa cada número, podrás entender cualquier fracción.",
  ),
  LearnSlide(
    imagePath: "assets/learn/num_deno.png",
    titleEn: "",
    descEn: "The top number, or numerator, refers to a certain number of those parts. It lets us know how much we're talking about. And the bottom number, or denominator, is the number of parts a whole is divided into.",
    titleEs: "",
    descEs: "El número superior, o numerador, se refiere a cierta cantidad de partes. Nos dice de cuánto hablamos. Y el número inferior, o denominador, indica en cuántas partes se ha dividido el todo.",
  ),
  LearnSlide(
    titleEn: "Reading fractions",
    descEn: "When we read or talk about fractions, we use special numbers called ordinal numbers. A good way to remember this is that many of them are the same numbers you use when you're putting things in order: third, fourth, fifth, and so on.\n\nYou might know some of these numbers already. For example, when you share half a chocolate with your friend, you both are eating 1/2 of the chocolate.",
    titleEs: "Leyendo fracciones",
    descEs: "Cuando leemos o hablamos de fracciones, usamos números especiales llamados números ordinales. Una buena forma de recordarlos es que muchos de ellos son los mismos que usas al poner cosas en orden: tercero, cuarto, quinto, etc.\n\nProbablemente ya conoces algunos. Por ejemplo, cuando compartes medio chocolate con tu amigo, ambos están comiendo 1/2 del chocolate.",
  ),
  LearnSlide(
    imagePath: "assets/learn/reading.png",
    titleEn: "",
    descEn: "If you had a pizza with eight slices, each slice would be 1/8 of the pizza. You'd read that like this: one-eighth.",
    titleEs: "",
    descEs: "Si tuvieras una pizza con ocho porciones, cada porción sería 1/8 de la pizza. Lo leerías así: un octavo.",
  ),
  LearnSlide(
    imagePath: "assets/learn/ordinal.png",
    titleEn: "",
    descEn: "Here are some of the most commonly used fractions. \nA good rule to remember is that most ordinal numbers end in \"th.\" \nSo, 1/20 is one-twentieth. 1/35 is one-thirty-fifth.",
    titleEs: "",
    descEs: "Aquí tienes algunas de las fracciones más comunes.\nUna buena regla para recordar es que la mayoría de los números ordinales terminan en \"avo\" o \"ésimo\" en español.\nAsí que 1/20 sería un vigésimo. 1/35 sería un trigésimo quinto.",
  ),
  LearnSlide(
    titleEn: "Mixed numbers",
    descEn: "Sometimes you might see a fraction next to a whole number. We call this a mixed number.",
    titleEs: "Números mixtos",
    descEs: "A veces podrías ver una fracción junto a un número entero. A esto lo llamamos número mixto.",
  ),
  LearnSlide(
    imagePath: "assets/learn/mixed.png",
    titleEn: "",
    descEn: "What if you pour 1 whole cup of tea, then fill only 2/3 of another cup? You'd read 1 2/3 like this: one and two-thirds. Remember, the whole number is always first.",
    titleEs: "",
    descEs: "¿Qué pasa si sirves una taza completa de té y luego llenas solo 2/3 de otra taza? Leerías 1 2/3 así: uno y dos tercios. Recuerda, el número entero siempre va primero.",
  ),
];
