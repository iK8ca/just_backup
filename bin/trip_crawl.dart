// import 'dart:html';
import 'dart:io'as io;
import 'package:html/parser.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:csv/csv.dart';

void main() async {
  const Map<String, String> config = {
    "tripAdvisorEmail": "jaykchen@mail.com",
    "tripAdvisorPassword": "Sunday228",
    "_2CaptchaAPIKey": "{my2CaptchaAPIKey}"
  };

  const args = [
    "--disable-dev-shm-usage",
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-accelerated-2d-canvas",
    "--disable-gpu",
    "--lang=en-US,en",
    "--disable-extensions"
    // `--user-data-dir=${puppyDataDir}`,
  ];

  var browser;
  try {
    browser = await puppeteer.launch(
      headless: false,
      devTools: false,
      ignoreHttpsErrors: true,
      ignoreDefaultArgs: args,
    );
  } catch (e) {
    print('Unable to launch chrome');
    // return two functions to silent errors
    // return [() => {}, () => {}];
    return;
  }

  var page = await browser.newPage();
  const url = "https://www.tripadvisor.com/";
  print("Opening " + url);

  try {
    await page.goto(url, wait: Until.networkIdle);
  } catch (e) {
    print("Unable to visit " + url);
    await browser.close();
    return;
  }

  // Flow 3 => Clicking the sign in button
  try {
    // await page.click('a._1JOGv2rJ _1_M9wxW9 _1qMtXLO6 _3yBiBka1');
    await page.click('div.pnI_yZEP');
    // await page.click('a[href*="RegistrationController"]');
    print("Clicked Sign In button");
    Future.delayed(Duration(seconds: 3));

  } catch (e) {
    print("Unable to click the sign in button");
    return;
  }
  // try {
  //   await page.waitForSelector('div.coreWrapper');
  //   // await page.waitForNavigation(wait: Until.networkIdle);
  // } catch (e) {
  //   print("could not wait for navigation");
  // }
  // const elementHandle = await page.$('.iframe-class');
  // const frame = await elementHandle.contentFrame();

  // var authFrame = await page.$('#ssoButtons > span > span.textContainer');
  // var authFrame = await page.$('div.coreWrapper');
  // var authFrame = await page.querySelect('a./RegistrationController');
  // var authFrame = await page.querySelect('a[href^="/RegistrationController"]');
  // var iframe = frames.find(f => f.name() === 'bookDesc_iframe'); // name or id for the frame

  // const paragraphs = await iframe.$$('p');


  // Flow 4 => Clicking the Continue with Email button
//   final authFrame = page
//       .frames().$eval("a", "a => a./RegistrationController");
// print(authFrame.runtimeType);

  var authFrame = page.frame.childframe();
  // var authFrame = page.frames.Where((frame) => frame.name == '.overlayRegFrame');
  var screenshot = await authFrame.screenshot();
  await io.File('example.png').writeAsBytes(screenshot);
  await page.emulateMediaType(MediaType.screen);//   var text = await frame.$eval('.selector', 'el => el.textContent');
//   print(text);
//
//   final authFrame = page
//       .frames();
//   .find((frame) => /RegistrationController/i.test(frame.url()));
// print(authFrame.runtimeType);
  try {
    // final continueBtn = await page.waitForSelector('.regEmailContinue');
    final popup =await authFrame.$('.regBody');



    await authFrame.click('.regEmailContinue');

    // await continueBtn.click();


    Future.delayed(Duration(seconds: 3));


    print("Clicked Continue with Email button");
  } catch (e) {
    print("Unable to click the Continue with Email button");
    return;
  }

  // Flow 5 => Reading the provided login credentials
  // final {
  // tripAdvisorEmail,
  // tripAdvisorPassword,
  // _2CaptchaAPIKey,
  // } = require("../config");

  // Flow 6 => Filling in the authentication details
  try {
    dynamic emailField = await page.waitForSelector(
        '#regSignIn input[type="email"]');
    await emailField.click(clickCount: 3);
    await emailField.type(config['tripAdvisorEmail'], delay: 75);
    print("Filled in email");
  } catch (e) {
    print("Unable to write to the email field");
    return;
  }

  try {
    dynamic passField = await page.waitForSelector(
        '#regSignIn input[type="password"]');
    await passField.click(clickCount: 3);
    await passField.type(config['tripAdvisorPassword'], delay: 75);
    print("Filled in password");
  } catch (e) {
    print("Unable to write to the password field");
    return;
  }

  try {
    await page("#regSignIn .regSubmitBtn");
  } catch (e) {
    print("Could not click the login button");
  }

  // var document = parse();

  // Flow 8 => Clicking the Hotels Link
  try {
    await page.evaluate(() =>
        page.querySelector('a[href^="/Hotels"]').click()
    );
    print("Clicked Hotels Link");
  } catch (e) {
    print("Unable to click the hotels link");
    await browser.close(); // close chrome on error
    return; // exit the scraper function
  }

  // Flow 9 => Typing London
  try {
    await page.waitFor(2500); // wait a bit before typing
    await page.keyboard.type("London");
    print("Typed London");
  } catch (e) {
    print("Unable to type London");
    await browser.close(); // close chrome on error
    return; // exit the scraper function
  }

  // Flow 10 => CLicking London
  try {
    var london = await page.waitForSelector(
        'form[action="/Search"] a[href*="London"]'
    );
    await london.click();
    try {
      await page.waitForNavigation(waitUntil: "networkidle0");
    } catch (e) {}
    print("Clicked London");
  } catch (e) {
    print("Unable to click london");
    await browser.close(); // close chrome on error
    return; // exit the scraper function
  }

  // Flow 11 => Extracting the names, services, prices, and ratings & reviews of listed hotels
  List<dynamic> extractedListings = [];
  dynamic listings;

  var hotelsInfo;
  // try {
  //   hotelsInfo = await page.evaluate(() => {
  //   listings = document.querySelectorAll('.listItem');
  //       var listingsLen = listings.length;
  //
  //       for (let i = 0; i < listingsLen; i++)
  //   {
  //     try {
  //       const listing = listings[i];
  //       const name = listing
  //           .querySelector(".listing_title a")
  //           .innerText;
  //       const services = (
  //           listing
  //               .querySelector(".icons_list")
  //               .innerText || ""
  //       ).replace("\n", ", ");
  //       const price = listing
  //           .querySelector(".price")
  //           .innerText;
  //       const ratings = listing
  //           .querySelector(".ui_bubble_rating")
  //           .getAttribute("alt");
  //       const reviews = listing
  //           .querySelector(".review_count")
  //           .innerText;
  //
  //       extractedListings.push({ name, services, price, ratings, reviews});
  //     } catch (e) {}
  //   }
  //
  //   return extractedListings;
  // });

  // do anything with hotelsInfo
  // print("Hotels Info: ${hotelsInfo.toString()}");
  // } catch (e) {
  // print("Unable to extract hotels listings");
  // }

  // Flow 12 => Exiting Chrome
  await browser.close();

  String fileName;
  if (!hotelsInfo || hotelsInfo.length < 1) return; // exit the function if no hotels

  // Flow 13 => Saving extracted hotels to a JSON file
  hotelsInfo.toJson.openwriteFile(io.File('hotels.json'));

  // Flow 14 => Saving extracted hotels to a CSV file

  io.File f = io.File('hotels.csv');
  String csv = const ListToCsvConverter().convert(hotelsInfo);
  f.writeAsString(csv);


}

