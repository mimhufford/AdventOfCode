using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day21 : Day
    {
        public Day21() : base(21) { }

        protected override void Solve()
        {
            var input = LongCSV.ToArray();
            var c = new IntCodeComputer();
            c.Flash(input);

            // Jump if any holes and you can land
            // J = !(A and B and C) and D
            var program = new string[] {
                "NOT A J", // !A
                "NOT J J", // A
                "AND B J", // A & B
                "AND C J", // A & B & C
                "NOT J J", // !(A & B & C)
                "AND D J", // !(A & B & C) & D
                "WALK",
            };

            c.Run(string.Join('\n', program).Append('\n').Select(c => (long)c).ToArray());
            Part1 = c.outputs.Last().ToString();

            // Jump if any holes and you can land, and you can jump or walk again
            // J = !(A and B and C) and D and (E or H)
            program = new string[] {
                "NOT A J", // !A
                "NOT J J", // A
                "AND B J", // A & B
                "AND C J", // A & B & C
                "NOT J J", // !(A & B & C)
                "AND D J", // !(A & B & C) & D
                "OR  E T", //
                "OR  H T", //
                "AND T J", // !(A & B & C) & D & (E | H)
                "RUN",
            };

            c.Flash(input);
            c.Run(string.Join('\n', program).Append('\n').Select(c => (long)c).ToArray());
            Part2 = c.outputs.Last().ToString();
        }
    }
}