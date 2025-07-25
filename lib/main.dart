import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';
import 'dart:html';
import 'package:screenshot/screenshot.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_io/io.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



import 'package:url_launcher/url_launcher.dart';

final Uri tiktokurl = Uri.parse('https://www.tiktok.com/@hybriidbox.apps');
final Uri igurl = Uri.parse('https://www.instagram.com/hybriidbox.apps');

Future<void> main() async {

  // Makes sure all Flutter widgets are ready before we do async stuff
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase and links your app to your Firebase project
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logEvent(name: 'app_launch');
  runApp(SpotifyApp());
}

String networkimage =
    'https://5.imimg.com/data5/QW/UW/SS/SELLER-90552772/plain-white-tile-250x250.jpg';
String albumname = 'Album';
String albumartist = 'Artist';
String releaseyear = '2025';
String releaseyear2 = '2025';
String openingtext = 'Connecting to Spotify API';
List<String> trackTitles = ["Track 1", "Track 2", "Track 3", "Track 4"];
String authtoken = 'Unauthorized';
String errortext = "Spotify Album Poster Creator v3.4";
String setView = "Loading";
List<Color> postercolors = [
Color(0xFFF3EDEC),
  Colors.white,
  Colors.grey,
  Color(0xff211e1e),
  Colors.black,
  Color(0xff99c262),
  Color(0xff7e94d7),
  Color(0xffc75e57),
  Color(0xffd0ac3f),
];
Color posterColor = Color(0xFFF3EDEC);
Color posterTextColor = Colors.black;

double posterwidth = 395;
double textwidth = 700;
double textheight = 40;
double albumsize = 23;
bool posterwidthused = false;
bool textwidthused= false;
bool textheightused = false;
bool albumsizeused = false;
int adjustby = 15;

bool isMobile = false;
bool connected = false;
bool visibile2 = false;
bool visibleSetting = true;
bool moreSetting = false;
bool colorSetting = false;
bool connectingText = true;
bool textShadow = true;
bool hasAlbum = false;
bool coverborder = true;

List<Color> squarecolors = [
  Colors.black,
  Colors.grey,
  Colors.black,
  Colors.grey
];
List<Color> squarecolors6 = [
  Colors.black,
  Colors.grey,
  Colors.black,
  Colors.grey,
  Colors.black,
  Colors.grey,
  Colors.grey,
  Colors.black,
  Colors.grey,
  Colors.black,
];

class SpotifyApp extends StatelessWidget {
  const SpotifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.black, // Change primary color
          sliderTheme: SliderThemeData(
            activeTrackColor: Colors.black, // Change the active slider color
            inactiveTrackColor: Colors.grey, // Change inactive slider color
            thumbColor: Colors.grey, // Change the thumb color
          ),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all(Colors.black12),
          )),
      home: Spot(),
    );
  }
}

class Spot extends StatefulWidget {
  const Spot({super.key});

  @override
  State<Spot> createState() => _SpotState();
}

//different styles
//faint picture
class _SpotState extends State<Spot> {
  PaletteGenerator? _paletteGenerator;


  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> getColors(String image) async {
    print("running get colors on +" + image);

    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(image),
      size: const Size(200, 200), // Adjust size for performance
    );
    print("final palette set ");

    setState(() {
      print('running state!');
      _paletteGenerator = paletteGenerator;
      squarecolors = paletteGenerator.colors.take(4).toList();
      print(squarecolors);
      if (squarecolors.isEmpty) {
        squarecolors = [Colors.black, Colors.grey, Colors.black, Colors.grey];
      }
      // Get 4 prominent colors
    });
  }

  Future<void> getColors6(String image) async {
    print("running get colors on +" + image);

    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(image),
      size: const Size(200, 200), // Adjust size for performance
    );
    print("final palette set ");

    setState(() {
      print('running state!');
      _paletteGenerator = paletteGenerator;
      squarecolors6 = paletteGenerator.colors.take(10).toList();
      print(squarecolors6);
      if (squarecolors.isEmpty) {
        squarecolors6 = [
          Colors.black,
          Colors.grey,
          Colors.black,
          Colors.grey,
          Colors.black,
          Colors.grey,
          Colors.grey,
          Colors.black,
          Colors.grey,
          Colors.black,
        ];
      }
      // Get 4 prominent colors
    });
  }

  Future<void> runEasyAPI() async {
    print("Starting");
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/mewtwo'));
    print(response.body);
    Map<String, dynamic> response2 = jsonDecode(response.body);
    print(response2['abilities'][1]['ability']['name']);
  }

  final outerController = ScrollController();
  final innerController = ScrollController();

  Future<void> _launchtiktokUrl() async {
    if (!await launchUrl(tiktokurl)) {
      throw Exception('Could not launch');
    }
  }

  Future<void> _launchinstagramUrl() async {
    if (!await launchUrl(igurl)) {
      throw Exception('Could not launch');
    }
  }

  Future<void> runSpotifyAPI() async {
    print("Starting");
    final response = await http
        .post(Uri.parse('https://accounts.spotify.com/api/token'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'grant_type': 'client_credentials',
      'client_id': 'd34e73870ae04a9c97d2295d4e87e58f',
      'client_secret': 'd358576659694ae1a4eda98972345883'
    });
    print(response.body);
    Map<String, dynamic> response2 = jsonDecode(response.body);
    print(response2['access_token']);
  }

  Future<void> getAuthKey() async {
    print("getting auth key");
    var response = await http
        .get(Uri.parse("https://hybriidbox.pythonanywhere.com/spotifyauth"));
    var response3 = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print("got auth key from localhost");
      setState(() {
        connected = true;
        connectingText = false;
        authtoken = response3['authcode']; // Trigger a rebuild
      });
      print("set variable");
    } else {
      print("autherror");
    }
  }

  Future<void> getAlbum(String album) async {
    print("Starting album");
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/albums/$album'),
      headers: {'Authorization': 'Bearer $authtoken'},
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      print("response was 200");
      Map<String, dynamic> response2 = jsonDecode(response.body);
      print(response2['images'][0]['url']);
      // print(response2);
      setState(() {
        networkimage = response2['images'][0]['url'];
        getColors(networkimage);
        getColors6(networkimage);
        albumname = response2['name'];
        albumartist = response2['artists'][0]['name'];
        releaseyear = response2['release_date'];
        releaseyear2 = releaseyear.substring(0, 4);
        trackTitles = (response2['tracks']['items'] as List)
            .map((track) => track['name'] as String)
            .toList();
        trackTitles = cleanTrackTitles(trackTitles);
        print("Original track titles: $trackTitles");
        print(trackTitles);
        //colorSetting = true;
        //connected = false;
        hasAlbum = true;
      });

      try {
        final response = await http.post(
          Uri.parse('https://hybriidbox.pythonanywhere.com/album'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'choice': albumname}),
        );

        FirebaseAnalytics.instance.logEvent(
          name: 'postercreated',
          parameters: {'album': " $albumname/${_textController.text}"},
        );

        if (response.statusCode == 200) {
          print('logged album name');
          print(response.body);
        } else {
          print('Failed to log choice: ${response.body}');
        }
      } catch (e) {
        print('Error sending choice: $e');
      }
    } else {
      print(response.body);
      print("response was not 200");
      setState(() {
        errortext = "Could Not Find Album";
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          errortext = "Spotify Album Poster Creator v3.4";
        });
      });
    }
  }

  bool hoverstatus = false;
  final TextEditingController _textController = TextEditingController();

  List<String> cleanTrackTitles(List<String> tracks) {
    return tracks.map((title) {
      int index = title.indexOf('('); // Find index of '('
      return index != -1 ? title.substring(0, index).trim() : title.trim();
    }).toList();
  }

  void error() {
    Future.delayed(const Duration(milliseconds: 15000), () {
      setState(() {
        openingtext = "Couldn't Connect, please try again later.";
      });
    });
  }

  final yourScrollController = ScrollController();
  ScreenshotController screenshotController = ScreenshotController();

  bool _assetsLoaded = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getAuthKey());
    print("initState Called");
    error();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAssets());


  }

  Future<void> _loadAssets() async {
    await Future.wait([

      precacheImage(AssetImage('assets/hbappslogo.png'), context),
      precacheImage(AssetImage('assets/wall.png'), context),

    ]);
    setState(() {
      // _assetsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (!_assetsLoaded) {
      return Scaffold(
        backgroundColor: Color(0xFFDADADA),
          body: Center(
            child: Column(
                mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,
              children: [
                Expanded(
                  child: Container(

                  ),
                ),

                Text(
                  "Introducing...",
                  style: TextStyle(
                      fontFamily: 'Schyler',
                      fontSize: 20),
                  // Handles long text
                  softWrap: true,

                  // Allows wrapping
                ),
                Text(
                  "The Spotify Album Poster Creator",
                  style: TextStyle(
                      fontFamily: 'Schyler',
                      fontSize: 20),
                  // Handles long text
                  softWrap: true,

                  // Allows wrapping
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [

                    Expanded(
                        child: Container(

                      ),
                    ),
                    Text(
                      "Website Loading",
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          fontSize: 20),
                      // Handles long text
                      softWrap: true,

                      // Allows wrapping
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    LoadingAnimationWidget
                        .twoRotatingArc(
                      color: Colors.black,
                      size: 20,
                    ),
                    Expanded(
                      child: Container(

                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(

                  ),
                ),
              ],
            ),
          ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F3F3),
            ),
          ),

          // Center(
          //   child: ListView(
          //     children: [
          //       GestureDetector(
          //
          //         child: Container(
          //           width: 200,
          //           height: 200,
          //           color: Colors.orangeAccent,
          //           child: Text("Tap to test Spotify"),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 30,
          //       ),
          //       GestureDetector(
          //         onTap: runSpotifyAPI,
          //         child: Container(
          //           width: 200,
          //           height: 200,
          //           color: Colors.greenAccent,
          //           child: Text("Tap to test Spotify"),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/wall.png"),
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.6), // adjust opacity here
                  BlendMode.modulate,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,

                  child: Row(children: [
                    SizedBox(
                        width:10,
                    ),
                    Opacity(
                      opacity: 0.8,
                      child: Container(
                        width: 50,

                          child: Image.asset(
                            'assets/hbappslogo.png',
                            fit: BoxFit
                                .cover, // Adjust to fill the container
                          ),
                      ),
                    ),
                    Expanded(
                      child: Container(

                    ),
                    ),

                  ],)
              ),
            ],
          ),


          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Center(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                              width: 1200,
                              height: 1600,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: posterTextColor),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 7,
                                      blurRadius: 14,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: posterColor),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 1020,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: coverborder ? 1.1 : 0,
                                              color: coverborder
                                                  ? posterTextColor
                                                  : Color(0xF5EDEC),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: !textShadow
                                                    ? Color(0x5F5EDEC)
                                                    : Colors.black26,
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                offset: Offset(1,
                                                    1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Image.network(
                                            networkimage,
                                            fit: BoxFit
                                                .cover, // Adjust to fill the container
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Container(
                                              // color: Colors.green,

                                                child: Stack(
                                              children: [
                                                // Row(
                                                //   children: [
                                                //     Expanded(
                                                //         child: Container(
                                                //       height: double.infinity,
                                                //       color: Colors.grey,
                                                //       child: ListView.builder(
                                                //           itemCount: 2,
                                                //           itemBuilder:
                                                //               (BuildContext
                                                //                       context,
                                                //                   int index) {
                                                //             return Container(
                                                //               color:
                                                //                   Colors.green,
                                                //               width: 10,
                                                //               height: 20,
                                                //             );
                                                //           }),
                                                //     )),
                                                //     Expanded(
                                                //         child: Container(
                                                //       height: double.infinity,
                                                //       color: Colors.teal,
                                                //     ))
                                                //   ],
                                                // )
                                                Wrap(
                                                  runSpacing: 7.0,
                                                  spacing: 0,
                                                  direction: Axis.vertical,
                                                  children: [
                                                    for (int i = 0;
                                                        i < trackTitles.length;
                                                        i++)
                                                      Container(
                                                        width: textwidth,

                                                        height: textheight,
                                                        child: FittedBox(
                                                            alignment: Alignment.centerLeft,
                                                            child: Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                (i + 1).toString() +
                                                                    ": " +
                                                                    trackTitles[
                                                                            i]
                                                                        .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontFamily: 'Schyler',
                                                                    shadows: [
                                                                      Shadow(
                                                                        blurRadius:
                                                                            13.0, // shadow blur
                                                                        color: !textShadow
                                                                            ? Color(0x5F5EDEC)
                                                                            : Colors.black26, // shadow color
                                                                        offset: Offset(
                                                                            2.0,
                                                                            2.0), // how much shadow will be shown
                                                                      ),
                                                                    ],
                                                                    color: posterTextColor),
                                                                // Handles long text
                                                                softWrap: true,
                                                                // Allows wrapping
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Spacer(),
                                                    Container(
                                                      height: 23,
                                                      width: 23,
                                                      decoration: BoxDecoration(
                                                        color: squarecolors[0],
                                                        border: Border.all(
                                                          width: 1,
                                                          color: posterTextColor,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: !textShadow
                                                                ? Color(0x5F5EDEC)
                                                                : Colors.black26,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Container(
                                                      height: 23,
                                                      width: 23,
                                                      decoration: BoxDecoration(
                                                        color: squarecolors[1],
                                                        border: Border.all(
                                                          width: 1,
                                                          color: posterTextColor,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: !textShadow
                                                                ? Color(0x5F5EDEC)
                                                                : Colors.black26,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Container(
                                                      height: 23,
                                                      width: 23,
                                                      decoration: BoxDecoration(
                                                        color: squarecolors[2],
                                                        border: Border.all(
                                                          width: 1,
                                                          color: posterTextColor,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: !textShadow
                                                                ? Color(0x5F5EDEC)
                                                                : Colors.black26,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Container(
                                                      height: 23,
                                                      width: 23,
                                                      decoration: BoxDecoration(
                                                        color: squarecolors[3],
                                                        border: Border.all(
                                                          width: 1,
                                                          color: posterTextColor,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: !textShadow
                                                                ? Color(0x5F5EDEC)
                                                                : Colors.black26,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Spacer(),
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        Container(



                                                          constraints:
                                                              const BoxConstraints(
                                                            maxWidth: 160,
                                                          ),
                                                          child: Text(
                                                            albumname,
                                                            textAlign: TextAlign.right,

                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Trajan Pro',

                                                                shadows: [
                                                                  Shadow(
                                                                    blurRadius:
                                                                        20.0, // shadow blur
                                                                    color: !textShadow
                                                                        ? Color(
                                                                            0x5F5EDEC)
                                                                        : Colors
                                                                            .black26, // shadow color
                                                                    offset: Offset(
                                                                        2.0,
                                                                        2.0), // how much shadow will be shown
                                                                  ),
                                                                ],
                                                                fontSize: albumsize,
                                                                color:
                                                                    posterTextColor),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 13,
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, -10),
                                                      child: Row(
                                                        children: [
                                                          Spacer(),
                                                          Container(
                                                            width: 100,
                                                            height: 20,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: FittedBox(
                                                                child: Text(
                                                                  albumartist,
                                                                  style: TextStyle(
                                                                      fontFamily: 'Schyler',
                                                                      shadows: [
                                                                        Shadow(
                                                                          blurRadius:
                                                                              10.0, // shadow blur
                                                                          color: !textShadow
                                                                              ? Color(0x5F5EDEC)
                                                                              : Colors.black26, // shadow color
                                                                          offset: Offset(
                                                                              2.0,
                                                                              2.0), // how much shadow will be shown
                                                                        ),
                                                                      ],
                                                                      fontSize: 60,
                                                                      color: posterTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                      offset: Offset(0, -10),
                                                      child: Row(
                                                        children: [
                                                          Spacer(),
                                                          Container(
                                                            width: 100,
                                                            height: 14,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: FittedBox(
                                                                child: Text(
                                                                  releaseyear2,

                                                                  style: TextStyle(
                                                                      fontFamily: 'Schyler',
                                                                      shadows: [
                                                                        Shadow(
                                                                          blurRadius:
                                                                              15.0, // shadow blur
                                                                          color: !textShadow
                                                                              ? Color(0x5F5EDEC)
                                                                              : Colors.black26, // shadow color
                                                                          offset: Offset(
                                                                              2.0,
                                                                              2.0), // how much shadow will be shown
                                                                        ),
                                                                      ],
                                                                      fontSize: 50,
                                                                      color: posterTextColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  Visibility(
                    visible: !colorSetting,
                    child: Visibility(
                      visible: visibleSetting,
                      child: Center(
                        child: Text(
                          errortext,
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              fontSize: 10,
                              color: Colors.black54),
                          // Handles long text
                          softWrap: true,

                          // Allows wrapping
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: colorSetting,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          colorSetting = false;
                          connected = true;
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: hoverstatus == false ? 1.3 : 1.9,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 2,
                                blurRadius: 15,
                                offset:
                                    Offset(1, 5), // changes position of shadow
                              ),
                            ],
                            color: Color(0xBEE0E0E0)),
                        child: Center(
                          child: Text(
                            "Back to Settings",
                            style:
                                TextStyle(fontFamily: 'Schyler', fontSize: 15),
                            // Handles long text
                            softWrap: true,

                            // Allows wrapping
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),

              Visibility(
                visible: visibleSetting,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastOutSlowIn,
                  width: MediaQuery.of(context).size.width / 1.06,
                  height: (!colorSetting && connected && MediaQuery.of(context).size.height <= 600)
                      ? MediaQuery.of(context).size.height * 0.4
                      : colorSetting
                      ? 230
                      : connected
                      ? moreSetting
                      ? 140
                      : MediaQuery.of(context).size.width > 1000
                      ? 170
                      : MediaQuery.of(context).size.width > 884
                      ? 190
                      : MediaQuery.of(context).size.width > 500
                      ? 310
                      : 330
                      : 50,


                  decoration: BoxDecoration(
                      border: const Border(
                        top: BorderSide(
                            width: 1.4, color: Colors.black), // Top border
                        left: BorderSide(
                            width: 1.4, color: Colors.black), // Left border
                        right: BorderSide(
                            width: 1.4, color: Colors.black), // Right border
                        bottom: BorderSide(
                            width: 1.4,
                            color: Colors.black), // Remove the bottom border
                      ),
                      borderRadius:
                          BorderRadius.circular(colorSetting ? 30 : !moreSetting ? 50 : 40),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 3,
                          blurRadius: 30,
                          offset: Offset(1, 5), // changes position of shadow
                        ),
                      ],
                      color: Color(0x49BDBCBC)), //bottomboxdecoration
                  child: Stack(
                    children: [
                      Center(
                        child: Stack(//appstack
                          children: [
                            Visibility(
                              visible: connected,
                              child: Scrollbar(
                                controller: yourScrollController,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      !moreSetting ? 0 : 40),
                                  child: Stack(
                                    children: [
                                      ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(
                                          scrollbars: true,
                                          dragDevices: {
                                            PointerDeviceKind.mouse,
                                            PointerDeviceKind.touch,
                                          },
                                        ),
                                        child: SingleChildScrollView(
                                          controller: yourScrollController,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Wrap(
                                              runSpacing: 8.0,
                                              spacing: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  80,
                                              children: [
                                                Container(
                                                  width: 250,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1.3,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          spreadRadius: 2,
                                                          blurRadius: 15,
                                                          offset: Offset(1,
                                                              5), // changes position of shadow
                                                        ),
                                                      ],
                                                      color: Color(0xBEF3F3F3)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Transform.translate(
                                                      offset: Offset(0, -3),
                                                      child: TextFormField(
                                                        controller:
                                                            _textController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Enter Spotify Album ID Here',
                                                          border:
                                                              InputBorder.none,
                                                          isDense: true,
                                                        ),
                                                        autofocus: true,
                                                        onFieldSubmitted:
                                                            (value) {
                                                          getAlbum(value);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    getAlbum(
                                                        _textController.text);

                                                  },
                                                  child: Container(
                                                    width: 150,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 2.0,
                                                            color: Color(
                                                                0xBE504C46)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                        color:
                                                            Color(0xBED7CDC5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Create Poster",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Schyler',
                                                              fontSize: 15),
                                                          // Handles long text
                                                          softWrap: true,

                                                          // Allows wrapping
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: !visibile2,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        visibile2 = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 110,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width:
                                                                hoverstatus ==
                                                                        false
                                                                    ? 1.3
                                                                    : 1.9,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(1,
                                                                  5), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Color(
                                                              0xBEE0E0E0)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Tutorial",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Schyler',
                                                                fontSize: 15),
                                                            // Handles long text
                                                            softWrap: true,

                                                            // Allows wrapping
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: !visibile2,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        visibile2 = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 110,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width:
                                                            hoverstatus ==
                                                                false
                                                                ? 1.3
                                                                : 1.9,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(1,
                                                                  5), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Color(
                                                              0xBEE0E0E0)),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(10.0),
                                                        child: Center(
                                                          child: Text(
                                                            "Poster Size",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                'Schyler',
                                                                fontSize: 15),
                                                            // Handles long text
                                                            softWrap: true,

                                                            // Allows wrapping
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (colorSetting == true) {
                                                      setState(() {
                                                        colorSetting = false;
                                                        connected = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        colorSetting = true;
                                                        connected = false;
                                                      });
                                                    }
                                                    FirebaseAnalytics.instance.logEvent(
                                                      name: 'postercolorpressed',

                                                    );
                                                    print("logged color");
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.fastOutSlowIn,
                                                    width: hasAlbum == false
                                                        ? 120
                                                        : 150,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width:
                                                              hasAlbum == false
                                                                  ? 1.3
                                                                  : 3,
                                                          color: hasAlbum ==
                                                                  false
                                                              ? Colors.black
                                                              : Color(
                                                                  0xFF277A1D),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(hasAlbum == false
                                                                ? 25
                                                                : 30,),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: hasAlbum ==
                                                                    false
                                                                ? Colors.black38
                                                                : Color(
                                                                    0x56277A1D),
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                        color:
                                                            Color(0xBEE0E0E0)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      child: Stack(
                                                        children: [
                                                          Row(children: [
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              color: Color(
                                                                  0x44FF8800),
                                                            )),
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              color: Color(
                                                                  0x884EB01C),
                                                            )),
                                                            Expanded(
                                                                child:
                                                                    Container(
                                                              color: Color(
                                                                  0xBE5471AF),
                                                            ))
                                                          ]),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1),
                                                            child: Center(
                                                              child: Text(
                                                                "Poster Color",
                                                                style:
                                                                    TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        shadows: [
                                                                          Shadow(
                                                                            blurRadius:
                                                                                10.0, // shadow blur
                                                                            color:
                                                                                Colors.black26, // shadow color
                                                                            offset:
                                                                                Offset(2.0, 2.0), // how much shadow will be shown
                                                                          ),
                                                                        ],
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14),
                                                                // Handles long text
                                                                softWrap: true,

                                                                // Allows wrapping
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    try {
                                                      // Capture the screenshot
                                                      final image =
                                                          await screenshotController
                                                              .capture();

                                                      if (image != null) {
                                                        // Convert to base64 and create a downloadable link
                                                        final base64Image =
                                                            base64Encode(image);
                                                        final anchor =
                                                            AnchorElement(
                                                                href:
                                                                    'data:application/octet-stream;base64,$base64Image')
                                                              ..download =
                                                                  "SpotifyPoster.png" // Name of the downloaded file
                                                              ..target =
                                                                  'blank';

                                                        // Append the anchor to the document and simulate a click
                                                        document.body!
                                                            .append(anchor);
                                                        anchor.click();
                                                        anchor
                                                            .remove(); // Clean up after the click
                                                      }
                                                    } catch (e) {
                                                      print(
                                                          "Error capturing or downloading the image: $e");
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: hoverstatus ==
                                                                  false
                                                              ? 1.3
                                                              : 1.9,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                        color:
                                                            Color(0xBEE0E0E0)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              "Save Poster",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Schyler',
                                                                  fontSize: 13),
                                                              // Handles long text
                                                              softWrap: true,

                                                              // Allows wrapping
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Icon(
                                                              Icons.save_alt,
                                                              color:
                                                                  Colors.black,
                                                              size: 13.0,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 140,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1.3,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(30),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(1,
                                                                  5), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Color(
                                                              0xBEF3F3F3)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    if (albumsizeused == false){
                                                                      FirebaseAnalytics.instance.logEvent(
                                                                        name: 'album_title_size_changed',
                                                                      );

                                                                    }
                                                                    setState(() {
                                                                      albumsizeused = true;
                                                                    });
                                                                    print(textheight
                                                                        .toString() +
                                                                        ": textheight");
                                                                    setState(() {
                                                                      albumsize =
                                                                          (albumsize -
                                                                              3)
                                                                              .clamp(
                                                                              10,
                                                                              50);
                                                                      ;
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    height: 30,
                                                                    child: Center(
                                                                      child: Text(
                                                                        "-",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                            'Schyler',
                                                                            fontSize:
                                                                            20),
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                            Colors.black12,
                                                                            spreadRadius:
                                                                            2,
                                                                            blurRadius:
                                                                            15,
                                                                            offset:
                                                                            Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                                  ),
                                                                ),
                                                              )),
                                                          Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    if (albumsizeused == false){
                                                                      FirebaseAnalytics.instance.logEvent(
                                                                        name: 'album_title_size_changed',
                                                                      );

                                                                    }
                                                                    setState(() {
                                                                      albumsizeused = true;
                                                                    });
                                                                    print(textheight
                                                                        .toString() +
                                                                        ": textheight");
                                                                    setState(() {
                                                                      albumsize =
                                                                          (albumsize +
                                                                              3)
                                                                              .clamp(
                                                                              10,
                                                                              50);
                                                                      ;
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    height: 30,
                                                                    child: Center(
                                                                      child: Text(
                                                                        "+",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                            'Schyler',
                                                                            fontSize:
                                                                            20),
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                            Colors.black12,
                                                                            spreadRadius:
                                                                            2,
                                                                            blurRadius:
                                                                            15,
                                                                            offset:
                                                                            Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Album Title Size",
                                                      style: TextStyle(
                                                          fontFamily: 'Schyler',
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 140,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1.3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(1,
                                                                  5), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Color(
                                                              0xBEF3F3F3)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (textheightused == false){
                                                                  FirebaseAnalytics.instance.logEvent(
                                                                    name: 'text_height_changed',
                                                                  );

                                                                }

                                                                setState(() {
                                                                  textheightused = true;
                                                                });
                                                                print(textheight
                                                                        .toString() +
                                                                    ": textheight");
                                                                setState(() {
                                                                  textheight =
                                                                      (textheight -
                                                                          5)
                                                                          .clamp(
                                                                              0,
                                                                              3000);
                                                                  ;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "-",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                15,
                                                                            offset:
                                                                                Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                              ),
                                                            ),
                                                          )),
                                                          // Expanded(
                                                          //   flex: 5,
                                                          //   child: SliderTheme(
                                                          //     data:
                                                          //         SliderThemeData(
                                                          //       overlayColor: Colors
                                                          //           .transparent,
                                                          //       thumbColor:
                                                          //           Colors.grey,
                                                          //       activeTrackColor:
                                                          //           Colors
                                                          //               .black,
                                                          //       inactiveTrackColor:
                                                          //           Colors
                                                          //               .black12,
                                                          //     ),
                                                          //     child: Slider(
                                                          //       value:
                                                          //           textheight,
                                                          //       min: 10,
                                                          //       max: 30,
                                                          //       divisions: 400,
                                                          //       onChanged:
                                                          //           (double
                                                          //               value) {
                                                          //         setState(() {
                                                          //           textheight =
                                                          //               value;
                                                          //         });
                                                          //       },
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (textheightused == false){
                                                                  FirebaseAnalytics.instance.logEvent(
                                                                    name: 'text_height_changed',
                                                                  );

                                                                }
                                                                setState(() {
                                                                  textheightused =true;

                                                                });
                                                                print(textheight
                                                                        .toString() +
                                                                    ": textheight");
                                                                setState(() {
                                                                  textheight =
                                                                      (textheight +
                                                                              5)
                                                                          .clamp(
                                                                              0,
                                                                              3000);
                                                                  ;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "+",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                15,
                                                                            offset:
                                                                                Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Song Height",
                                                      style: TextStyle(
                                                          fontFamily: 'Schyler',
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 140,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1.3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(1,
                                                                  5), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Color(
                                                              0xBEF3F3F3)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (textwidthused == false){
                                                                  FirebaseAnalytics.instance.logEvent(
                                                                    name: 'text_width_changed',
                                                                  );

                                                                }
                                                                setState(() {
                                                                  textwidthused = true;

                                                                });
                                                                print(textheight
                                                                        .toString() +
                                                                    ": textheight");
                                                                setState(() {
                                                                  textwidth =
                                                                      (textwidth -
                                                                          10)
                                                                          .clamp(
                                                                              70,
                                                                              250);
                                                                  ;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "-",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                15,
                                                                            offset:
                                                                                Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                              ),
                                                            ),
                                                          )),
                                                          // SliderTheme(
                                                          //   data: SliderThemeData(
                                                          //     overlayColor: Colors
                                                          //         .transparent,
                                                          //     thumbColor:
                                                          //         Colors.grey,
                                                          //     activeTrackColor:
                                                          //         Colors.black,
                                                          //     inactiveTrackColor:
                                                          //         Colors.black12,
                                                          //   ),
                                                          //   child: Slider(
                                                          //     value: textwidth,
                                                          //     min: 100,
                                                          //     max: 250,
                                                          //     divisions: 400,
                                                          //     onChanged:
                                                          //         (double value) {
                                                          //       setState(() {
                                                          //         textwidth = value;
                                                          //       });
                                                          //     },
                                                          //   ),
                                                          // ),
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (textwidthused == false){
                                                                  FirebaseAnalytics.instance.logEvent(
                                                                    name: 'text_width_changed',
                                                                  );

                                                                }
                                                                setState(() {
                                                                  textwidthused = true;

                                                                });
                                                                print(textwidth
                                                                        .toString() +
                                                                    ": textwidth");
                                                                setState(() {
                                                                  textwidth =
                                                                      (textwidth +
                                                                          10)
                                                                          .clamp(
                                                                              100,
                                                                              13000);
                                                                  ;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "+",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                15,
                                                                            offset:
                                                                                Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Song Width",
                                                      style: TextStyle(
                                                          fontFamily: 'Schyler',
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),

                                                Column(
                                                  children: [
                                                    Container(
                                                      width: 140,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1.3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: 2,
                                                              blurRadius: 15,
                                                              offset: Offset(1,
                                                                  5), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Color(
                                                              0xBEF3F3F3)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (posterwidthused == false){
                                                                  FirebaseAnalytics.instance.logEvent(
                                                                    name: 'poster_width_changed',
                                                                  );

                                                                }
                                                                setState(() {
                                                                  posterwidthused = true;

                                                                });
                                                                print(textheight
                                                                        .toString() +
                                                                    ": textheight");
                                                                setState(() {
                                                                  posterwidth =
                                                                      (posterwidth -
                                                                              25)
                                                                          .clamp(
                                                                              380,
                                                                              800);
                                                                  ;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "-",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                15,
                                                                            offset:
                                                                                Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                              ),
                                                            ),
                                                          )),
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                if (posterwidthused == false){
                                                                  FirebaseAnalytics.instance.logEvent(
                                                                    name: 'poster_width_changed',
                                                                  );

                                                                }
                                                                setState(() {
                                                                  posterwidthused = true;

                                                                });
                                                                print(textheight
                                                                        .toString() +
                                                                    ": textheight");
                                                                setState(() {
                                                                  posterwidth =
                                                                      (posterwidth +
                                                                              20)
                                                                          .clamp(
                                                                              380,
                                                                              800);
                                                                  ;
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "+",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Schyler',
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          width: hoverstatus == false
                                                                              ? 1.3
                                                                              : 1.9,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                130),
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.black12,
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                15,
                                                                            offset:
                                                                                Offset(1, 5), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                        color: Color(
                                                                            0xBEB4B4B4)),
                                                              ),
                                                            ),
                                                          )),

                                                          // SliderTheme(
                                                          //   data: SliderThemeData(
                                                          //     overlayColor: Colors
                                                          //         .transparent,
                                                          //     thumbColor:
                                                          //         Colors.grey,
                                                          //     activeTrackColor:
                                                          //         Colors.black,
                                                          //     inactiveTrackColor:
                                                          //         Colors.black12,
                                                          //   ),
                                                          //   child: Slider(
                                                          //     value: posterwidth,
                                                          //     min: 380,
                                                          //     max: 800,
                                                          //     divisions: 400,
                                                          //     onChanged:
                                                          //         (double value) {
                                                          //       setState(() {
                                                          //         posterwidth =
                                                          //             value;
                                                          //       });
                                                          //     },
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Poster Width",
                                                      style: TextStyle(
                                                          fontFamily: 'Schyler',
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),

                                                // InkWell(
                                                //   onTap: () async {
                                                //     setState(() {
                                                //       visibile2 = true;
                                                //     });
                                                //   },
                                                //   child: Container(
                                                //     width: 40,
                                                //     height: 40,
                                                //     decoration: BoxDecoration(
                                                //         border: Border.all(
                                                //           width: hoverstatus ==
                                                //                   false
                                                //               ? 1.3
                                                //               : 1.9,
                                                //         ),
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(30),
                                                //         boxShadow: const [
                                                //           BoxShadow(
                                                //             color:
                                                //                 Colors.black12,
                                                //             spreadRadius: 2,
                                                //             blurRadius: 15,
                                                //             offset: Offset(1,
                                                //                 5), // changes position of shadow
                                                //           ),
                                                //         ],
                                                //         color:
                                                //             Color(0xBEE0E0E0)),
                                                //     child: Center(
                                                //         child: IconButton(
                                                //       onPressed:
                                                //           _launchtiktokUrl,
                                                //       icon: FaIcon(
                                                //           FontAwesomeIcons
                                                //               .tiktok),
                                                //       iconSize: 20,
                                                //       color: Colors.black,
                                                //     )),
                                                //   ),
                                                // ),
                                                // InkWell(
                                                //   onTap: () async {
                                                //     setState(() {
                                                //       visibile2 = true;
                                                //     });
                                                //   },
                                                //   child: Container(
                                                //     width: 40,
                                                //     height: 40,
                                                //     decoration: BoxDecoration(
                                                //         border: Border.all(
                                                //           width: hoverstatus ==
                                                //                   false
                                                //               ? 1.3
                                                //               : 1.9,
                                                //         ),
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(30),
                                                //         boxShadow: const [
                                                //           BoxShadow(
                                                //             color:
                                                //                 Colors.black12,
                                                //             spreadRadius: 2,
                                                //             blurRadius: 15,
                                                //             offset: Offset(1,
                                                //                 5), // changes position of shadow
                                                //           ),
                                                //         ],
                                                //         color:
                                                //             Color(0xBEE0E0E0)),
                                                //     child: Center(
                                                //         child: IconButton(
                                                //       onPressed:
                                                //           _launchinstagramUrl,
                                                //       icon: FaIcon(
                                                //           FontAwesomeIcons
                                                //               .instagram),
                                                //       iconSize: 20,
                                                //       color: Colors.black,
                                                //     )),
                                                //   ),
                                                // ),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      if (textShadow == true) {
                                                        textShadow = false;
                                                      } else {
                                                        textShadow = true;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: hoverstatus ==
                                                                  false
                                                              ? 1.3
                                                              : 1.9,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                        color:
                                                            Color(0xBEE0E0E0)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Shadow On/Off",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Schyler',
                                                              fontSize: 10),
                                                          // Handles long text
                                                          softWrap: true,

                                                          // Allows wrapping
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      if (coverborder == true) {
                                                        coverborder = false;
                                                      } else {
                                                        coverborder = true;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 120,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: hoverstatus ==
                                                                  false
                                                              ? 1.3
                                                              : 1.9,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            spreadRadius: 2,
                                                            blurRadius: 15,
                                                            offset: Offset(1,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                        color:
                                                            Color(0xBEE0E0E0)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Center(
                                                        child: Text(
                                                          "Cover Border On/Off",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Schyler',
                                                              fontSize: 10),
                                                          // Handles long text
                                                          softWrap: true,

                                                          // Allows wrapping
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 100,
                                                // ),
                                                // Center(
                                                //   child: Text(
                                                //     "Spotify Authorization Code: " +
                                                //         authtoken,
                                                //     style: TextStyle(
                                                //         fontFamily: 'Schyler',
                                                //         fontSize: 5,
                                                //         color: Colors.black38),
                                                //     // Handles long text
                                                //     softWrap: true,
                                                //
                                                //     // Allows wrapping
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: connectingText,
                              child: Center(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: FittedBox(
                                        child: Row(
                                          children: [
                                            Text(
                                              openingtext,
                                              style: TextStyle(
                                                  fontFamily: 'Schyler',
                                                  fontSize: 20),
                                              // Handles long text
                                              softWrap: true,

                                              // Allows wrapping
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            LoadingAnimationWidget
                                                .twoRotatingArc(
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: colorSetting,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Recommended Colors For Album ",
                                      style: TextStyle(
                                          fontFamily: 'Schyler', fontSize: 13),
                                      // Handles long text
                                      softWrap: true,

                                      // Allows wrapping
                                    ),
                                    Stack(
                                      children: [
                                        Visibility(
                                          visible: !hasAlbum,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: hoverstatus == false
                                                        ? 1.3
                                                        : 1.9,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 2,
                                                      blurRadius: 15,
                                                      offset: Offset(1,
                                                          5), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Color(0xBDEACCCC)),
                                              child: Center(
                                                child: Text(
                                                  "Poster Must Have an Album",
                                                  style: TextStyle(
                                                      fontFamily: 'Schyler',
                                                      fontSize: 15,
                                                      color: Color(0xFD810D0D)),
                                                  // Handles long text
                                                  softWrap: true,

                                                  // Allows wrapping
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: hasAlbum,
                                          child: Row(
                                            children: [
                                              for (int i = 0;
                                              i < squarecolors6.length;
                                              i++)
                                                Expanded(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(5.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            posterColor =
                                                            squarecolors6[i];
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              color:
                                                              squarecolors6[i],
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black12,
                                                                  spreadRadius: 2,
                                                                  blurRadius: 5,
                                                                  offset: Offset(1,
                                                                      1), // changes position of shadow
                                                                )
                                                              ],
                                                              border: Border.all(
                                                                width: squarecolors6[
                                                                i] ==
                                                                    Colors.black
                                                                    ? 2.3
                                                                    : 1.3,
                                                                color: squarecolors6[
                                                                i] ==
                                                                    Colors.black
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                              )),
                                                        ),
                                                      ),
                                                    ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Default Poster Colors",
                                      style: TextStyle(
                                          fontFamily: 'Schyler', fontSize: 14),
                                      // Handles long text
                                      softWrap: true,

                                      // Allows wrapping
                                    ),
                                    Row(
                                      children: [
                                        for (int i = 0;
                                            i < postercolors.length;
                                            i++)
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  posterColor = postercolors[i];
                                                });
                                              },
                                              child: Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color: postercolors[i],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(1,
                                                            1), // changes position of shadow
                                                      )
                                                    ],
                                                    border: Border.all(
                                                      width: postercolors[i] ==
                                                              Colors.black
                                                          ? 2.3
                                                          : 1.3,
                                                      color: postercolors[i] ==
                                                              Colors.black
                                                          ? Colors.white
                                                          : Colors.black,
                                                    )),
                                              ),
                                            ),
                                          ))
                                      ],
                                    ),

                                    Text(
                                      "Text Color",
                                      style: TextStyle(
                                          fontFamily: 'Schyler', fontSize: 14),
                                      // Handles long text
                                      softWrap: true,

                                      // Allows wrapping
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                posterTextColor = Colors.black;
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(1,
                                                          1), // changes position of shadow
                                                    )
                                                  ],
                                                  border: Border.all(
                                                      width: 2.3,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                posterTextColor = Colors.white;
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(1,
                                                          1), // changes position of shadow
                                                    )
                                                  ],
                                                  border: Border.all(
                                                      width: 2.3,
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                posterTextColor =
                                                    Colors.white60;
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(1,
                                                          1), // changes position of shadow
                                                    )
                                                  ],
                                                  border: Border.all(
                                                      width: 2.3,
                                                      color: Colors.black)),
                                            ),
                                          ),
                                        )),
                                        // Expanded(
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.all(7.0),
                                        //       child: InkWell(
                                        //         onTap: () {
                                        //           showModalBottomSheet(
                                        //             context: context,
                                        //             builder: (context) => Container(
                                        //               padding: const EdgeInsets.all(2),
                                        //
                                        //               child: Column(
                                        //                 children: [
                                        //                   Expanded(
                                        //                     child: ColorPicker(
                                        //                       pickerColor: pickerColor,
                                        //                       onColorChanged: changeColor,
                                        //                     ),
                                        //                   ),
                                        //                   const SizedBox(height: 16),
                                        //                   ElevatedButton(
                                        //                     child: const Text('Got it'),
                                        //                     onPressed: () {
                                        //                       setState(() => posterTextColor = pickerColor);
                                        //                       Navigator.of(context).pop();
                                        //                     },
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           );
                                        //         },
                                        //
                                        //
                                        //         child: Container(
                                        //           height: 35,
                                        //           decoration: BoxDecoration(
                                        //               color: Colors.grey,
                                        //               borderRadius:
                                        //               BorderRadius.circular(20),
                                        //               boxShadow: const [
                                        //                 BoxShadow(
                                        //                   color: Colors.black12,
                                        //                   spreadRadius: 2,
                                        //                   blurRadius: 5,
                                        //                   offset: Offset(1,
                                        //                       1), // changes position of shadow
                                        //                 )
                                        //               ],
                                        //               border: Border.all(
                                        //                   width: 2.3,
                                        //                   color: Colors.black)),
                                        //         ),
                                        //       ),
                                        //     )),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Column(
                        children: [],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 17,
                  ),
                  Visibility(
                    visible: connected,
                    child: Visibility(
                      visible: true,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            if (visibleSetting == true) {
                              visibleSetting = false;
                            } else {
                              visibleSetting = true;
                            }
                          });
                        },
                        child: Container(
                          width: 160,
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: hoverstatus == false ? 1.3 : 1.9,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                  offset: Offset(
                                      1, 5), // changes position of shadow
                                ),
                              ],
                              color:  Color(0x49BDBCBC)),
                          child: Center(
                            child: Text(
                              visibleSetting
                                  ? "Hide Settings"
                                  : "Open Settings",
                              style: TextStyle(
                                  fontFamily: 'Schyler', fontSize: 15),
                              // Handles long text
                              softWrap: true,

                              // Allows wrapping
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 49,
                  ),
                  Visibility(
                    visible: connected,
                    child: Visibility(
                      visible: visibleSetting,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            if (moreSetting == true) {
                              moreSetting = false;
                            } else {
                              moreSetting = true;
                            }
                          });
                        },
                        child: Container(
                          height: 30,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: hoverstatus == false ? 1.3 : 1.9,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 15,
                                  offset: Offset(
                                      1, 5), // changes position of shadow
                                ),
                              ],
                              color:  Color(0x49BDBCBC)),
                          child: Center(
                            child: Text(
                              !moreSetting
                                  ? "Minimize Settings"
                                  : "Expand Settings",
                              style: TextStyle(
                                  fontFamily: 'Schyler', fontSize: 15),
                              // Handles long text
                              softWrap: true,

                              // Allows wrapping
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 50,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              // Stack(
              //   children: [
              //     Slider(
              //       value: posterwidth,
              //       min: 400,
              //       max: 1000,
              //       divisions: 400,
              //
              //       onChanged: (double value) {
              //         setState(() {
              //           posterwidth = value;
              //         });
              //       },
              //     ),
              //     Slider(
              //       value: textwidth,
              //       min: 100,
              //       max: 190,
              //       divisions: 400,
              //
              //       onChanged: (double value) {
              //         setState(() {
              //           textwidth = value;
              //         });
              //       },
              //     ),
              //     Container(
              //       width: double.infinity,
              //       height: 30,
              //       color: Colors.yellow,
              //       child: TextFormField(
              //         decoration: InputDecoration(
              //           hintText: 'Email',
              //           labelText: 'Email',
              //         ),
              //         autofocus: true,
              //         onFieldSubmitted: (value) {
              //           getAlbum(value);
              //         },
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
          Visibility(
            visible: visibile2,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(width: double.infinity, height: double.infinity),
            ),
          ),
          Visibility(
            visible: visibile2,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          1, 1), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Stack(
                                children: [
                                  Center(
                                    child:
                                        LoadingAnimationWidget.twoRotatingArc(
                                      color: Colors.black,
                                      size: 12,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/infov1.png',
                                    fit: BoxFit
                                        .cover, // Adjust to fill the container
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                visibile2 = false;
                              });
                            },
                            child: Container(
                              width: 110,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: hoverstatus == false ? 1.3 : 1.9,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                      offset: Offset(
                                          1, 5), // changes position of shadow
                                    ),
                                  ],
                                  color: Color(0xBEE0E0E0)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    "Exit",
                                    style: TextStyle(
                                        fontFamily: 'Schyler', fontSize: 15),
                                    // Handles long text
                                    softWrap: true,

                                    // Allows wrapping
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
