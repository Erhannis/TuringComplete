import 'dart:collection';

//TODO Eh, a little weird....
import 'package:flutter/material.dart';

enum Dir {
  LEFT, STAY, RIGHT
}

extension DirExt on Dir {
  String get shortString {
    switch (this) {
      case Dir.LEFT:
        return "<";
      case Dir.STAY:
        return "X";
      case Dir.RIGHT:
        return ">";
    }
  }
}

class StateTransition<SYMBOL> {
  final Dir move;
  final SYMBOL write;
  final int toState;

  StateTransition(this.move, this.write, this.toState);

  @override
  String toString() {
    return "${write}${move.shortString}${toState}";
  }
}

class _LLSymbol<SYMBOL> extends LinkedListEntry<_LLSymbol<SYMBOL>> {
  SYMBOL symbol;
  final SYMBOL _blank;
  _LLSymbol(this.symbol, this._blank);

  @override
  _LLSymbol<SYMBOL> get previous {
    _LLSymbol<SYMBOL>? prev = super.previous;
    if (prev != null) {
      return prev;
    }
    prev = new _LLSymbol(_blank, _blank);
    super.insertBefore(prev);
    return prev;
  }

  @override
  _LLSymbol<SYMBOL> get next {
    _LLSymbol<SYMBOL>? next = super.next;
    if (next != null) {
      return next;
    }
    next = new _LLSymbol(_blank, _blank);
    super.insertAfter(next);
    return next;
  }

  @override
  String toString() {
    return '$symbol';
  }
}

class SpecialString {
  String text;
  bool special;

  SpecialString(this.text, [this.special = false]);
}

class TcEngine<SYMBOL> {
  final int HALT = -1;

  LinkedList<_LLSymbol<SYMBOL>> tape = new LinkedList();
  Map<Pair<int, SYMBOL>, StateTransition<SYMBOL>> stateTransitions = new Map();
  _LLSymbol<SYMBOL> head;
  int state = 0;
  SYMBOL blank;

  // I don't know how many states there are...but do I NEED to?
  TcEngine(this.blank) : head = new _LLSymbol(blank, blank) {
    tape.add(head);
  }

  TcEngine<SYMBOL> iterate() {
    if (state == HALT) {
      return this;
    }
    StateTransition<SYMBOL>? transition = stateTransitions[Pair(state, head.symbol)];
    if (transition == null) {
      // NOP
      //transition = new StateTransition(Dir.NONE, head.symbol, state);
      return this;
    }
    head.symbol = transition.write;
    switch (transition.move) {
      case Dir.LEFT:
        prev();
        break;
      case Dir.STAY:
        break;
      case Dir.RIGHT:
        next();
        break;
    }
    state = transition.toState;
    return this;
  }

  void playTransition(int state, SYMBOL symbol, StateTransition<SYMBOL> transition) {
    stateTransitions[Pair(state, symbol)] = transition;
  }

  void prev() {
    head = head.previous;
  }

  void next() {
    head = head.next;
  }

  SYMBOL current() {
    return head.symbol;
  }

  List<SpecialString> tapeView() {
    return tape.map((e) => new SpecialString("$e", e == head)).toList();
  }

  List<List<Pair<Pair<int, SYMBOL>, SpecialString>>> tableView() {
    var result = List<List<Pair<Pair<int, SYMBOL>, SpecialString>>>.empty(growable: true);
    var states = new HashSet<int>();
    var symbols = new HashSet<SYMBOL>();
    for (Pair<int, SYMBOL> k in stateTransitions.keys) {
      states.add(k.a);
      symbols.add(k.b);
    }
    for (SYMBOL symbol in symbols) {
      result.add(states.map((state) => Pair(Pair(state, symbol), new SpecialString("${stateTransitions[Pair(state, symbol)] ?? new StateTransition(Dir.STAY, symbol, state)}", (state == this.state && symbol == this.head.symbol)))).toList());
    }
    return result;
  }
}

class Pair<A,B> {
  final A a;
  final B b;

  Pair(this.a, this.b) : _hashCode = Object.hash(a, b);

  @override
  bool operator==(other) {
    if(other is! Pair<A,B>) {
      return false;
    }
    return a == other.a && b == other.b;
  }

  int _hashCode;
  @override
  int get hashCode {
    return _hashCode;
  }
}