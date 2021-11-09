import 'dart:collection';

enum Dir {
  LEFT, STAY, NONE
}

class StateTransition<SYMBOL> {
  final Dir move;
  final SYMBOL write;
  final int toState;

  StateTransition(this.move, this.write, this.toState);
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

class TcEngine<SYMBOL> {
  LinkedList<_LLSymbol<SYMBOL>> tape = new LinkedList();
  Map<Pair<int, SYMBOL>, StateTransition<SYMBOL>> stateTransitions = new Map();
  _LLSymbol<SYMBOL> head;
  SYMBOL blank;
  SYMBOL halt;

  TcEngine(this.blank, this.halt) : head = new _LLSymbol(blank, blank) {
    tape.add(head);
  }

  TcEngine<SYMBOL> iterate() {

    return this;
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