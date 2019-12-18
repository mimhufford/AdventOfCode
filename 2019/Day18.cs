using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day18 : Day
    {
        public Day18() : base(18) { }

        protected override void Solve()
        {
            var map = new HashSet<(int x, int y)>();
            var keys = new Dictionary<char, (int x, int y)>();
            var doors = new Dictionary<char, (int x, int y)>();
            (int x, int y) entrance = (0, 0);

            var input = Lines.ToArray();
            for (var y = 0; y < input.Length; y += 1)
            {
                for (var x = 0; x < input[y].Length; x += 1)
                {
                    var tile = input[y][x];
                    switch (tile)
                    {
                        case '#': break;
                        case '.': map.Add((x, y)); break;
                        case '@': entrance = (x, y); map.Add((x, y)); break;
                        default:
                            if (tile >= 'A' && tile <= 'Z') doors.Add(tile, (x, y));
                            else keys.Add(tile, (x, y));
                            map.Add((x, y));
                            break;
                    }
                }
            }
        }
    }
}