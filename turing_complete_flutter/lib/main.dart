import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:turing_complete_flutter/tc_engine.dart';

const STATES = 4;
const SYMBOLS = 2;
const BLANK = 0;
const HAND_LIMIT = 5;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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

class DummyButton extends OutlinedButton {
  DummyButton({required Widget child}) : super(onPressed: null, child: child);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random rand = new Random();
  TcEngine<int> engine = new TcEngine(BLANK);
  List<StateTransition<int>> hand = List.empty(growable: true);

  _MyHomePageState() {
    _reset();
  }

  void _discardByIndex(int i) {
    hand.removeAt(i);
  }

  // ...Dart doesn't allow overloading?  Seriously?
  void _discardByCard(StateTransition<int> card) {
    hand.remove(card);
  }

  void _drawCard() {
    var card = new StateTransition<int>(rand.nextElement(Dir.values), rand.nextInt(SYMBOLS), rand.nextInt(STATES));
    hand.add(card);
    while (hand.length > HAND_LIMIT) {
      _discardByIndex(0);
    }
  }

  void _reset() {
    engine = new TcEngine<int>(BLANK);
    for (int state = 0; state < 4; state++) {
      for (int symbol = 0; symbol < 2; symbol++) {
        engine.playTransition(state, symbol, new StateTransition(Dir.STAY, symbol, state));
      }
    }
    hand.clear();
    for (int i = 0; i < HAND_LIMIT; i++){
      _drawCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(onPressed: () => setState(_reset), child: Text("Reset"),),
              Spacer(),
              OutlinedButton(onPressed: () => setState(() => engine.playTransition(rand.nextInt(STATES), rand.nextInt(SYMBOLS), new StateTransition(rand.nextElement(Dir.values), rand.nextInt(SYMBOLS), rand.nextInt(STATES)))), child: Text("Rand"),),
              Spacer(),
              DummyButton(child: Text("X")),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(onPressed: () => setState(() => engine.prev()), child: Text("<-"),),
              Spacer(),
              OutlinedButton(onPressed: () => setState(() => engine.iterate()), child: Text("Step"),),
              Spacer(),
              OutlinedButton(onPressed: () => setState(() => engine.next()), child: Text("->"),),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(onPressed: () => setState(() => _drawCard()), child: Text("Draw"),),
            ]),
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
              return Row(children: [Spacer(), Expanded(child: GridView.count(shrinkWrap: true, crossAxisCount: elems[0].length, children:
              elems.expand((e) => e.map((s) =>
                  DragTarget<StateTransition<int>>(builder: (context, candidateData, rejectedData) {
                    return Text(s.b.text, textAlign: TextAlign.center, style: TextStyle(fontWeight: s.b.special ? FontWeight.w900 : FontWeight.w100));
                  },
                  onAccept: (StateTransition<int> card) {
                    setState(() {
                      //engine.playTransition(state, symbol, transition);
                      _discardByCard(card);
                      engine.playTransition(s.a.a, s.a.b, card);
                      _drawCard();
                    });
                  },),)).toList(),
              ),),Spacer()]);
            }(),
            Spacer(),
            Row(children: [Spacer(), ...hand.map((e) => Draggable<StateTransition<int>>(data: e, feedback: DummyButton(child: new Text("$e")), child: new OutlinedButton(onPressed: () => print(e), child: Text("$e")), childWhenDragging: DummyButton(child: new Text("X")),)).toList(), Spacer()],)
          ],
        ),
      ),
    ));
  }
}

extension RandomExt on Random {
  T nextElement<T>(List<T> elements) {
    return elements[this.nextInt(elements.length)];
  }
}