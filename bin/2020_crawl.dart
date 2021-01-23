
import 'dart:io'as io;
import 'package:html/parser.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:csv/csv.dart';

void main() async {

 const Map<String, String> track_data = {
    'label_name': '20/20 Vision',
    'song_title': 'soundTitle__title',    //<span class="soundTitle__title sc-font g-type-shrinkwrap-inline g-type-shrinkwrap-large-primary"><span>Exit Planet Earth: Oxygen - Various Artists</span>
    'song_genre': 'sc-truncate sc-tagContent',    //<span class="sc-truncate sc-tagContent">Electronic</span>
    'song_length': 'playbackTimeline__duration',    //<div class="playbackTimeline__duration"><span class="sc-visuallyhidden">Duration: 1 minute 57 seconds</span><span aria-hidden="true">1:57</span></div>
  };




  const url = "https://soundcloud.com/2020visionrecordings/tracks";
  var browser = await puppeteer.launch();
  var page = await browser.newPage();
  await page.goto(url, wait: Until.domContentLoaded);
  var data = await page.$('div.soundTitle__usernameTitleContainer > a' );
  // data.screenshot();
  print(data.runtimeType);

  await browser.close();
}