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
            var screen = c.outputs.ToArray();
            var blocks = 0;
            for (int i = 2; i < screen.Length; i += 3) if (screen[i] == 2) blocks += 1;
            Part1 = blocks.ToString();

            var ballx = 0L;
            var padlx = 0L;
            var score = 0L;
            while (!c.done)
            {
                c.Run(ballx < padlx ? -1 : ballx > padlx ? 1 : 0);
                screen = c.outputs.ToArray();

                for (int i = 0; i < screen.Length; i += 3)
                {
                    var x = screen[i];
                    var y = screen[i + 1];
                    var o = screen[i + 2];
                    if (x == -1 && y == 0 && score < o) score = o;
                    else if (o == 3) padlx = x;
                    else if (o == 4) ballx = x;
                }
            }
            Part2 = score.ToString();
        }
    }
}