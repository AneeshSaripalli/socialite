class Soundex {
  static final Soundex _singleton = Soundex._internal();

  Map<String, List<String>> dict;
  Map<int, int> soundexMap;

  void _initSoundexMap() {
    soundexMap.putIfAbsent(asInt('b'), () => 1);
    soundexMap.putIfAbsent(asInt('f'), () => 1);
    soundexMap.putIfAbsent(asInt('p'), () => 1);
    soundexMap.putIfAbsent(asInt('v'), () => 1);

    soundexMap.putIfAbsent(asInt('c'), () => 2);
    soundexMap.putIfAbsent(asInt('g'), () => 2);
    soundexMap.putIfAbsent(asInt('j'), () => 2);
    soundexMap.putIfAbsent(asInt('k'), () => 2);
    soundexMap.putIfAbsent(asInt('q'), () => 2);
    soundexMap.putIfAbsent(asInt('s'), () => 2);
    soundexMap.putIfAbsent(asInt('x'), () => 2);
    soundexMap.putIfAbsent(asInt('z'), () => 2);

    soundexMap.putIfAbsent(asInt('d'), () => 3);
    soundexMap.putIfAbsent(asInt('t'), () => 3);

    soundexMap.putIfAbsent(asInt('l'), () => 4);

    soundexMap.putIfAbsent(asInt('m'), () => 5);
    soundexMap.putIfAbsent(asInt('n'), () => 5);

    soundexMap.putIfAbsent(asInt('r'), () => 6);
  }

  Soundex._internal() {
    dict = Map<String, List<String>>();
    soundexMap = Map<int, int>();

    _initSoundexMap();
  }

  int asInt(String s) {
    return s.codeUnitAt(0);
  }

  factory Soundex() {
    return _singleton;
  }

  String process(String word) {
    final int firstLetter = asInt(word);

    String builder = "";
    int index = 0;
    int lastCode;

    do {
      lastCode = word.codeUnitAt(index);

      builder += String.fromCharCode(lastCode);

      while (index < word.length && word.codeUnitAt(index) == lastCode) index++;
    } while (index < word.length);

    word = word.replaceAll(r'[aeiou]', '');

    return word;
  }

  void addDictionaryWord(String word) {
    if (dict[word] == null) {
      dict.putIfAbsent(word, () => List<String>());
    }
    dict[word].add(word);
  }
}
