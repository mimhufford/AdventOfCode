using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace AoC
{
    public class Day3 : Day
    {
        public Day3() : base(3) { }

        List<(int x, int y)> GeneratePath(IEnumerable<string> instructions)
        {
            var path = new List<(int, int)>();
            var x = 0;
            var y = 0;

            foreach (var instruction in instructions)
            {
                var dir = instruction[0];
                var amt = int.Parse(instruction.Substring(1));
                for (int i = 0; i < amt; i++)
                {
                    if (dir == 'U') y--;
                    else if (dir == 'D') y++;
                    else if (dir == 'L') x--;
                    else if (dir == 'R') x++;
                    path.Add((x, y));
                }
            }

            return path;
        }

        protected override void Solve()
        {
            var w1 = GeneratePath(Lines.First().Split(','));
            var w2 = GeneratePath(Lines.Last().Split(','));

            var intersections = w1.Intersect(w2);

            Part1 = intersections.Select(i => Math.Abs(i.x) + Math.Abs(i.y)).Min().ToString();
            Part2 = intersections.Select(i => w1.IndexOf(i) + w2.IndexOf(i) + 2).Min().ToString();
        }
    }
}