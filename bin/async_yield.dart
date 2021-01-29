//simple way to create iterator
//sync, sync*, async, async*, yield, yield* differences
void main() {
  print('create iterator');
  Iterable<int> numbers = getNumbers(3);
  print('starting to iterate...');
  for (int val in numbers) {
    print('$val');
  }
  print('end of main');
}
Iterable<int> getNumbers(int number) sync* {
  print('generator started');
  for (int i = 0; i < number; i++) {
    yield i;
  }
  print('generator ended');
}

void main() {
  print('create iterator');
  Stream<int> numbers = getNumbers(3);
  print('starting to listen...');
  numbers.listen((int value) {
    print('$value');
  });
  print('end of main');
}
Stream<int> getNumbers(int number) async* {
  print('waiting inside generator a bit :)');
  await new Future.delayed(new Duration(seconds: 5)); //sleep 5s
  print('started generating values...');
  for (int i = 0; i < number; i++) {
    await new Future.delayed(new Duration(seconds: 1)); //sleep 1s
    yield i;
  }
  print('ended generating values...');
}

void main() {
  print('create iterator');
  Iterable<int> numbers = getNumbersRecursive(3);
  print('starting to iterate...');
  for (int val in numbers) {
    print('$val');
  }
  print('end of main');
}
Iterable<int> getNumbersRecursive(int number) sync* {
  print('generator $number started');
if (number > 0) {
    yield* getNumbersRecursive(number - 1);
  }
  yield number;
print('generator $number ended');
}
