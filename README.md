# Snake Clone in Digital Mars D

Trying to pick up enough D to be dangerous. Used D for [Advent of Code][aoc]
2023 on [day 23][d23].

[aoc]: https://adventofcode.com/
[d23]: https://github.com/ripta/x/blob/cc2e3f1baa8d008e2d8b13dad86d867cca34ab4a/aoc-2023/day-23/solution-pt1.d

Requires `dmd` and `dub`.

Prerequisite: either (a) copy raylib.so/.a into root directory of this repo; or
(b) run `dub run raylib-d:install`.

On macOS, run `build.sh` or `run.sh`; see comments in file for reason. On other
platforms, `dmd build` and `dmd run` should be sufficient.
