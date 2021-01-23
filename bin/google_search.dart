import 'dart:io';
import 'package:puppeteer/puppeteer.dart';

extension IterableExtension<T> on Iterable<T> {
  firstOrNull() {
    if (this.isEmpty) {
      return null;
    } else {
      return this.first;
    }
  }
}

extension StringExtension on String {
  ifEmpty(String defaultValue) {
    if (this.isEmpty) {
      return defaultValue;
    } else {
      return this;
    }
  }
}

main(List<String> args) async {
  final String searchKeyword = args.join(" ").ifEmpty("puppeteer");

  final browser = await puppeteer.launch(
    headless: false,
    args: [
      "--guest",
      '--window-size=1280,800',
    ],
    slowMo: Duration(milliseconds: 50),
  );

  final Page page =
      (await browser.pages).firstOrNull() ?? (await browser.newPage());

  await page.setViewport(DeviceViewport(width: 1280, height: 800));

  await page.goto("https://google.com/");
  await page.type("input[name='q']", searchKeyword);
  await page.keyboard.press(Key.enter);

  await Future.delayed(Duration(seconds: 3));
  await browser.close();
}