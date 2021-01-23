
import 'dart:html';
import 'dart:io'as io;
import 'package:html/parser.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:csv/csv.dart';

void main() async {
  const url = "https://www.airbnb.com/s/homes?refinement_paths%5B%5D=%2Fhomes&search_type=section_navigation&property_type_id%5B%5D=8";
  var browser = await puppeteer.launch();
  var page = await browser.newPage();
  await page.goto(url, wait: Until.domContentLoaded);
  var data = await page.evaluate(() => {
 var root = Array.from(document.querySelectorAll("#FMP-target [itemprop='itemListElement']"));

      hotels = root.map(hotel => (Hotel {
      Name: hotel.querySelector('ol').parentElement.nextElementSibling.textContent.toString();
      Photo: hotel.querySelector("img").getAttribute("src");
      }));
  return hotels;
  });

  print(data);

  await browser.close();
}

class Hotel {
  String Name;
  String Photo;

  Hotel() {
  this.Name;
  this.Photo;
  }


}