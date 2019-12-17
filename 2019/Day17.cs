using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day17 : Day
    {
        public Day17() : base(17) { }

        protected override void Solve()
        {
            var c = new IntCodeComputer();
            c.Flash(LongCSV.ToArray());
            c.Run();

            var x = 0; var y = 0;
            var map = new HashSet<(int x, int y)>();

            while (c.outputs.Count > 0)
            {
                var tile = (char)c.outputs.Dequeue();

                switch (tile)
                {
                    case '.': x += 1; break;
                    case '#': map.Add((x, y)); x += 1; break;
                    case '^': map.Add((x, y)); x += 1; break;
                    case '>': map.Add((x, y)); x += 1; break;
                    case '<': map.Add((x, y)); x += 1; break;
                    case 'v': map.Add((x, y)); x += 1; break;
                    default: y += 1; x = 0; break;
                }
            }

            var intersections = 0;
            foreach (var tile in map)
            {
                var n = (tile.x, tile.y - 1);
                var e = (tile.x + 1, tile.y);
                var s = (tile.x, tile.y + 1);
                var w = (tile.x - 1, tile.y);

                if (map.Contains(n) && map.Contains(e) && map.Contains(s) && map.Contains(w))
                {
                    intersections += tile.x * tile.y;
                }
            }

            Part1 = intersections.ToString();
        }
    }
}