card game: Turing Complete
players build and modify a turing machine, each trying to bring about a certain tape state

goal fragment cards, ranked by difficulty
  allows for adjustable difficulty
symbol cards (strictly 1/0?  maybe an expansion adds rules for 3+ symbols?)
  tokens can be used instead, coins, rocks pushed up or down on a line
draw hand of maybe 7 state transition cards
  how deal with changing size of state count?
  ...COULD have a fixed state count?
    cards could have a little table of their next state according to state count

victory mechanisms
  maybe everybody has individual tape, or individual set of transitions, and at the end of THEIR turn they update their stuff
  or maybe update machine at end of round?
    unfair advantage to last player
    maybe everyone is in charge of one transition slot?
    still unfair in favor of last player, but less so
    then rotate play order at end of turn
  perhaps the machine is reset and runs for N steps, every turn?
    would sorta need an app or something
    and feels like a different kind of game


misc thoughts
  play transitions in pieces?
  collaborative (easy), vs competetive (hard)?
    collaborative could turn into one person directing and the others twiddling thumbs, though
  permit iterate without play card?
    otherwise, just wasting cards on irrelevant slots
  time limit?
  allow discard cards?
    refresh hand at cost of turn, perhaps
  start with random table, for something to work with?
  could do themed decks - 0/1, A/B/C/D, A/T/C/G, C/A/T/D/O/G
  note which direction is up, on a card

problems:
  tendency towards just overwriting the impending state
    how do we make it worthwhile to think ahead?
    make changes sticky?
    maybe transitions can't replace each other?
  what if two players have overlapping goals - one MUST win before the other?


configurations
  symbols
    01, ABCD
  competetive, cooperative
  hand size
  action count per turn
  action order
    place transition, step, next person
  can discard?
    at will?
    whole hand?
    uses turn?
  MUST place?
  MUST step?


notes
  saboteur style?
  points: how much of goal matched
  mark X as hard mode?
  transition slot as goal

  discard hand => no play card, no iterate (lets other players control board more, in exchange)
  alternate first player between rounds
  9 tape, play 1 card, iterate 3
  maybe scale #played & #iterate with #players?
