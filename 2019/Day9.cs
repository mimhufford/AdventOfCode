using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day9 : Day
    {
        public Day9() : base(9) { }

        protected override void Solve()
        {
            var memory = LongCSV.ToArray();
            var computer = new IntCodeComputer();

            computer.Flash(memory);
            computer.Run(1);
            Part1 = computer.outputs.Dequeue().ToString();

            computer.Flash(memory);
            computer.Run(2);
            Part2 = computer.outputs.Dequeue().ToString();
        }
    }
}