using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day13 : Day
    {
        public Day13() : base(13) { }

        protected override void Solve()
        {
            var c = new IntCodeComputer();
            c.Flash(LongCSV.ToArray());
            c.mem[0] = 2;
            c.Run();

            var blocks = 0;
            while (c.outputs.Count > 0)
            {
                c.outputs.Dequeue(); c.outputs.Dequeue();
                if (c.outputs.Dequeue() == 2) blocks += 1;
            }
            Part1 = blocks.ToString();

            var ballx = 0L;
            var padlx = 0L;
            var score = 0L;

            while (!c.done)
            {
                c.Run(ballx < padlx ? -1 : ballx > padlx ? 1 : 0);

                while (c.outputs.Count > 0)
                {
                    var x = c.outputs.Dequeue();
                    var y = c.outputs.Dequeue();
                    var o = c.outputs.Dequeue();
                    if (x == -1 && y == 0 && score < o) score = o;
                    else if (o == 3) padlx = x;
                    else if (o == 4) ballx = x;
                }
            }

            Part2 = score.ToString();
        }
    }
}