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
            var c = new IntCodeComputer();
            c.Flash(LongCSV.ToArray());

            // Ground = True, Hole = False
            // J = !A or !B or !C and D
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
        }
    }
}