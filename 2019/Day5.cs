using System;
using System.Linq;

namespace AoC
{
    public class Day5 : Day
    {
        public Day5() : base(5) { }

        protected override void Solve()
        {
            var memory = LongCSV.ToArray();
            var c = new IntCodeComputer();

            c.Flash(memory); c.Run(1);
            while (c.outputs.Count > 1) c.outputs.Dequeue();
            Part1 = c.outputs.Dequeue().ToString();

            c.Flash(memory); c.Run(5);
            Part2 = c.outputs.Dequeue().ToString();
        }
    }
}