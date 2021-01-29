void main() {
  const myString = 'This is a long string that I want to iterate over.';
  final myIterable = TextRuns(myString);
  for (var textRun in myIterable) {
    print(textRun);
  }
}

class TextRuns extends Iterable<String> {
  TextRuns(this.text);
  final String text;

  @override
  Iterator<String> get iterator => TextRunIterator(text);
}

class TextRunIterator implements Iterator<String> {
  TextRunIterator(this.text);
  final String text;

  String _currentTextRun;
  int _startIndex = 0;
  int _endIndex = 0;

  final breakChar = RegExp(' ');

  @override
  String get current => _currentTextRun;

  @override
  bool moveNext() {
    _startIndex = _endIndex;
    if (_startIndex == text.length) {
      _currentTextRun = null;
      return false;
    }
    final next = text.indexOf(breakChar, _startIndex);
    _endIndex = (next != -1) ? next + 1 : text.length;
    _currentTextRun = text.substring(_startIndex, _endIndex);
    return true;
  }
}
