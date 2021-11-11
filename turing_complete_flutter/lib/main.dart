import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:turing_complete_flutter/tc_engine.dart';

const STATES = 4;
const SYMBOLS = 2;
const BLANK = 0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'TuringComplete',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        primaryColor: Colors.red,
        //scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
        ).apply( // This isn't working
          bodyColor: Colors.orange,
          displayColor: Colors.blue,
        ),
      ),
      // theme: ThemeData.dark().copyWith(
      //   //primaryColor: Colors.green,
      // ),
      home: MyHomePage(title: 'TuringComplete'),
    );
    return app;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TcEngine<int> engine = new TcEngine(BLANK);

  _MyHomePageState() {
    _resetEngine();
  }

  void _resetEngine() {
    for (int state = 0; state < 4; state++) {
      for (int symbol = 0; symbol < 2; symbol++) {
        engine.playTransition(state, symbol, new StateTransition(Dir.STAY, symbol, state));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [OutlinedButton(onPressed: () => setState(_resetEngine), child: Text("Reset"),), Spacer()],
            ),
            Spacer(),
            Row(children: [Spacer(), ...engine.tapeView().map((e) => new Text(e.text, style: TextStyle(fontWeight: e.special ? FontWeight.w900 : FontWeight.w100),)).toList(), Spacer()],),
            // Text(
            //   '${engine.tapeString()}',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            Spacer(),
            (){
              var elems = engine.tableView();
              if (elems.length == 0) {
                return SizedBox.shrink();
              }
              // This was STUPID.  "Horizontal viewport was given unbounded height" can EAT DIRT.
              return Row(children: [Spacer(), Expanded(child: GridView.count(shrinkWrap: true, crossAxisCount: elems[0].length, children: elems.expand((e) => e.map((s) => Text(s.text, textAlign: TextAlign.center, style: TextStyle(fontWeight: s.special ? FontWeight.w900 : FontWeight.w100)))).toList(),),),Spacer()]);
            }(),
            Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(onPressed: () => setState(() => engine.playTransition(rand.nextInt(STATES), rand.nextInt(SYMBOLS), new StateTransition(rand.nextElement(Dir.values), rand.nextInt(SYMBOLS), rand.nextInt(STATES)))), child: Text("Rand"),),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(onPressed: () => setState(() => engine.prev()), child: Text("<-"),),
              Spacer(),
              OutlinedButton(onPressed: () => setState(() => engine.iterate()), child: Text("Step"),),
              Spacer(),
              OutlinedButton(onPressed: () => setState(() => engine.next()), child: Text("->"),),
            ]),
          ],
        ),
      ),
    );
  }
}

extension RandomExt on Random {
  T nextElement<T>(List<T> elements) {
    return elements[this.nextInt(elements.length)];
  }
}