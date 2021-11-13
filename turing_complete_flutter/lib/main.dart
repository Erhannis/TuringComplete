import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:turing_complete_flutter/tc_engine.dart';

import 'card_gen.dart' as cg;
import 'package:image/image.dart' as im;

typedef Symbol = String;

const STATES = 4;
const SYMBOLS = ["A", "B", "C", "D"];
const BLANK = "A";
const HAND_LIMIT = 7;

const C_LEFT = 0xFF4499CC;
const C_STAY = 0xFF444444;
const C_RIGHT = 0xFFCC9944;
const C_HEAD_BG = 0xFF302A22;
const C_GREENTEXT = 0xFF44CC99;
const C_PLAIN_BG = 0xFF222222;

const STATE_COLORS = [0xFFDB3AF8, 0xFF0000B8, 0xFF5A10E5, 0xFFEDD5F5];
const SYMBOL_COLORS = [0xFFC0E3AF, 0xFF345835, 0xFF8CFFCB, 0xFF79A121];

extension DirColors on Dir {
  int color() {
    switch (this) {
      case Dir.LEFT:
        return C_LEFT;
      case Dir.STAY:
        return C_STAY;
      case Dir.RIGHT:
        return C_RIGHT;
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    debugPaintSizeEnabled = false;
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
  TcEngine<Symbol> engine = new TcEngine(BLANK);
  List<StateTransition<Symbol>> hand = List.empty(growable: true);

  _MyHomePageState() {
    _reset();
  }

  void _discardByIndex(int i) {
    hand.removeAt(i);
  }

  // ...Dart doesn't allow overloading?  Seriously?
  void _discardByCard(StateTransition<Symbol> card) {
    hand.remove(card);
  }

  void _drawCard() {
    var card = randTransition();
    hand.add(card);
    while (hand.length > HAND_LIMIT) {
      _discardByIndex(0);
    }
  }

  void _reset() {
    engine = new TcEngine<Symbol>(BLANK);
    for (int state = 0; state < STATES; state++) {
      for (Symbol symbol in SYMBOLS) {
        engine.playTransition(state, symbol, new StateTransition(Dir.STAY, symbol, state));
      }
    }
    hand.clear();
    for (int i = 0; i < HAND_LIMIT; i++){
      _drawCard();
    }
  }

  StateTransition<Symbol> randTransition() {
    return new StateTransition(rand.nextElement(Dir.values), rand.nextElement(SYMBOLS), rand.nextInt(STATES));
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
              OutlinedButton(onPressed: () => setState(() => engine.playTransition(rand.nextInt(STATES), rand.nextElement(SYMBOLS), randTransition())),
                onLongPress: () => setState(() {
                  for (int state = 0; state < STATES; state++) {
                    for (Symbol symbol in SYMBOLS) {
                      engine.playTransition(state, symbol, randTransition());
                    }
                  }
                }), child: Text("Rand"),),
              Spacer(),
              OutlinedButton(onPressed: () {
                bool ROLL20 = false;
                List<cg.Card> cardsFront = [];
                List<cg.Card> cardsBack = [];
                final symbolBack = cg.Card([
                  cg.Text(["TC", ""], color: C_GREENTEXT),
                  cg.Text(["", "SYMBOL"], font: cg.FONT_05, color: C_GREENTEXT),
                ], bg: C_PLAIN_BG);
                final transitionBack = cg.Card([
                  cg.Text(["TC", ""], color: C_GREENTEXT),
                  cg.Text(["", "TRANSITION"], font: cg.FONT_025, color: C_GREENTEXT),
                ], bg: C_PLAIN_BG);
                //TODO Fix for arbitrary symbols
                cardsFront.add(cg.Card([
                  cg.Text(["<   "], color: C_LEFT),
                  cg.Text(["   >"], color: C_RIGHT),
                ], bg: C_HEAD_BG));
                cardsBack.add(cg.Card([cg.Text(["INSTRUCTIONS","GO","HERE"], font: cg.FONT_025, color: C_GREENTEXT)], bg: C_HEAD_BG));
                for (int i = 0; i < 10; i++) {
                  if (SYMBOLS.length == 2) {
                    cardsFront.add(cg.Card([cg.Text([SYMBOLS[0]], color: SYMBOL_COLORS[0])], bg: cg.ExtColor.invertXor(SYMBOL_COLORS[0])));
                    cardsBack.add(cg.Card([cg.Text([SYMBOLS[1]], color: SYMBOL_COLORS[1])], bg: cg.ExtColor.invertXor(SYMBOL_COLORS[1])));
                  } else if (SYMBOLS.length == 4) {
                    cardsFront.add(cg.Card([
                      cg.Text([SYMBOLS[0],"",""], angle: 0, color: SYMBOL_COLORS[0]),
                      cg.Text([SYMBOLS[1],"",""], angle: 180, color: SYMBOL_COLORS[1]),
                    ], bg: C_PLAIN_BG));
                    cardsBack.add(cg.Card([
                      cg.Text([SYMBOLS[2],"",""], angle: 0, color: SYMBOL_COLORS[2]),
                      cg.Text([SYMBOLS[3],"",""], angle: 180, color: SYMBOL_COLORS[3]),
                    ], bg: C_PLAIN_BG));
                  } else {
                    num angle = 360.0 / SYMBOLS.length;
                    cardsFront.add(cg.Card(
                      List<cg.Text>.generate(SYMBOLS.length, (s) => cg.Text([SYMBOLS[s],"",""], angle: s*angle, color: SYMBOL_COLORS[s])),
                      bg: cg.ExtColor.invertXor(SYMBOL_COLORS[0]))
                    );
                    cardsBack.add(symbolBack);
                  }
                }
                if (ROLL20) {
                  cg.genRoll20Cards(cardsFront, filenameBase: "bitsFront.png");
                  cg.genRoll20Cards(cardsBack, filenameBase: "bitsBack.png");
                } else {
                  cg.genTtsCards(cardsFront, filename: "bitsFront.png");
                  cg.genTtsCards(cardsBack, filename: "bitsBack.png");
                }
                cardsFront = [];
                cardsBack = [];
                for (int state = 0; state < STATES; state++) {
                  for (Symbol symbol in SYMBOLS) {
                    for (Dir dir in Dir.values) {
                      final card = cg.Card([
                        cg.Text([symbol.toString(), "", ""], color: SYMBOL_COLORS[SYMBOLS.indexOf(symbol)]),
                        cg.Text(["", dir.shortString, ""], color: dir.color()),
                        cg.Text(["", "", state.toString()], color: STATE_COLORS[state]),
                      ], bg: C_PLAIN_BG);
                      cardsFront.add(card);
                      cardsBack.add(transitionBack);
                    }
                  }
                }
                if (ROLL20) {
                  cg.genRoll20Cards(cardsFront, filenameBase: "transitionsFront.png");
                  cg.genRoll20Cards(cardsBack, filenameBase: "transitionsBack.png");
                } else {
                  cg.genTtsCards(cardsFront, filename: "transitionsFront.png");
                  cg.genTtsCards(cardsBack, filename: "transitionsBack.png");
                }
              }, child: Text("Cards")),
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
              OutlinedButton(onPressed: () => setState(() {
                final card = randTransition();
                if (rand.nextDouble() < 0.8) {
                  engine.playTransition(engine.state, engine.head.symbol, randTransition());
                } else {
                  engine.playTransition(rand.nextInt(STATES), rand.nextElement(SYMBOLS), randTransition());
                }
                engine.iterate();
              }), child: Text("AI"),),
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
              return Row(children: [Expanded(child: GridView.count(shrinkWrap: true, crossAxisCount: elems[0].length, children:
              elems.expand((e) => e.map((s) =>
                  DragTarget<StateTransition<Symbol>>(builder: (context, candidateData, rejectedData) {
                    return Container(margin: EdgeInsets.all(2), decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700, width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                        child: Column(children: [Spacer(), Text(s.b.text, textAlign: TextAlign.center, style: TextStyle(fontWeight: s.b.special ? FontWeight.w900 : FontWeight.w100)), Spacer()]));
                  },
                  onAccept: (StateTransition<Symbol> card) {
                    setState(() {
                      //engine.playTransition(state, symbol, transition);
                      _discardByCard(card);
                      engine.playTransition(s.a.a, s.a.b, card);
                      _drawCard();
                    });
                  },),)).toList(),
              ),),]);
            }(),
            Spacer(),
            Row(children: [Spacer(), ...hand.map((e) => Draggable<StateTransition<Symbol>>(data: e, feedback: DummyButton(child: new Text("$e")), child: new OutlinedButton(onPressed: () => print(e), child: Text("$e")), childWhenDragging: DummyButton(child: new Text("X")),)).toList(), Spacer()],)
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