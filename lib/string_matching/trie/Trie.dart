class Trie {
  int charContent;
  var children = new List<Trie>();
  bool isWord;

  Trie() {
    this.charContent = 0;
    children.length = 26;
    this.isWord = false;

    print(children);
  }

  void add(String str) {
    if (str.length == 0) {
      this.isWord = true;
      return;
    }
    int index = str.toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);

    charContent = str.toLowerCase().codeUnitAt(0);

    if (children.elementAt(index) == null) {
      children[index] = new Trie();
    }
    children[index].add(str.substring(1));
  }

  bool checkIfWord(String str) {
    if (str.isEmpty) return isWord;
    int index = str.toLowerCase().codeUnitAt(0) - 'a'.codeUnitAt(0);
    if (children[index] == null)
      return false;
    else
      return children[index].checkIfWord(str.substring(1));
  }
}
