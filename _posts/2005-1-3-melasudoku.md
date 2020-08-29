---
layout: post
title: "Me la Sudoku"
permalink: /melasudoku/
---
I discovered Sudoku on holiday in Lanzarote in 2005 and became so obsessed with it that I spent my first couple of days back at work writing a program to solve and generate new Sudokus. I was fascinated by the fact that it was impossible to tell the difference between a trivial and a fiendishly difficult Sudoku just by looking at it. The name "Me la Sudoku" is a play on the Spanish phrase "me la sudo" which is better left to your imagination.
<!--more-->

![MeLaSudoku](/assets/melasudoku.jpg)

I programmed a set of rules which I had discovered from solving Sudokus myself.

```
IfNotPossibleElsewhereRule
IfAppearsElsewhereRule
IfOnlyPossibleInRowOrColumnInBlockRule
IfOnlyPossibleInBlockInRowOrColumnRule
PairsTriplesEtcRule
PairsTriplesEtcRule2
OnlyOnePossibilityRule
TrialAndErrorRule
```

The program can randomly generate Sudokus of varying sizes that are solvable with a selection of the above rules. The easiest Sudokus (level 1) can be solved with only `IfNotPossibleElsewhereRule`, `IfAppearsElsewhereRule` and `OnlyOnePossibilityRule`. The hardest Sudokus (level 5) may require trial and error (or a more more sophisticated rule).

Since then, many much better Sudoku programs have become available but I like being able to generate Sudoku's that I know I will be able to solve without too much effort that are nevertheless still challenging (level 4). Somehow just writing this program "cured" me of my Sudoku obsession, because it was enough just to know that I *could* solve them.

You can find the C++ source code [here](https://github.com/teticio/MeLaSudoku).
