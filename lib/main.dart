import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.teal,
    );

    Widget avatar = Container(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              // clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'images/baby.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 18),
              child: Text(
                'Elliott',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          ],
        ));

    Widget titleSection = Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('Kandersteg, Switzerland',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ))
              ],
            )),
            FavoriteWidget(),
          ],
        ));

    // Widget buttonSection = Row(
    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     _buildButtonColumn(theme.accentColor, Icons.call, 'CALL'),
    //     _buildButtonColumn(theme.primaryColor, Icons.share, 'SHARE'),
    //     _buildButtonColumn(theme.primaryColorDark, Icons.near_me, 'ROUTE'),
    //   ],
    // );

    Container _buildSettingRow(String name, String value) {
      const double fontSize = 18;

      return Container(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ));
    }

    Widget settingsSection = Column(children: [
      _buildSettingRow('setting name', 'value'),
      _buildSettingRow('setting name 2', 'value 2')
    ]);

    void _goToStory() {}
    Widget buttonSection = Container(
        alignment: Alignment.center,
        child: OutlinedButton(
          child: Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'View Story',
                style: TextStyle(fontSize: 20),
              )),
          onPressed: _goToStory,
        ));

    // Widget textSection = const Padding(
    //   padding: EdgeInsets.all(32),
    //   child: Text(
    //     'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
    //     'Alps. Situated 1,578 meters above sea level, it is one of the '
    //     'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
    //     'half-hour walk through pastures and pine forest, leads you to the '
    //     'lake, which warms to 20 degrees Celsius in the summer. Activities '
    //     'enjoyed here include rowing, and riding the summer toboggan run.',
    //     softWrap: true,
    //   ),
    // );

    void _openMenu() {}

    return MaterialApp(
        title: 'Baby Binder',
        theme: theme,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                icon: Icon(Icons.menu),
                // color: Colors.red[500],
                onPressed: _openMenu,
                // enableFeedback: false,
              ),
              title: const Text('Baby Binder'),
            ),
            body: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    avatar,
                    Expanded(
                      child: settingsSection,
                    ),
                    buttonSection,
                  ],
                ))));
  }

  // Column _buildButtonColumn(Color color, IconData icon, String label) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(icon, color: color),
  //       Container(
  //         margin: const EdgeInsets.only(top: 8),
  //         color: color,
  //         height: 20,
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({Key? key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: SizedBox(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
