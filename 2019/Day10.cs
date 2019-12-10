using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day10 : Day
    {
        public Day10() : base(10) { }

        protected override void Solve()
        {
            var asteroids = new List<(int x, int y)>();

            var map = Lines.ToList();
            for (int y = 0; y < map.Count; y++)
            {
                var row = map[y];
                for (int x = 0; x < row.Length; x++)
                {
                    if (row[x] == '#')
                    {
                        asteroids.Add((x, y));
                    }
                }
            }

            var mostVisible = 0;
            for (int ai = 0; ai < asteroids.Count; ai++)
            {
                var a = asteroids[ai];
                var visible = 0;
                var angles = new HashSet<double>();

                for (int bi = 0; bi < asteroids.Count; bi++)
                {
                    if (ai == bi) continue;
                    var b = asteroids[bi];
                    var angle = Math.Atan2(a.x - b.x, a.y - b.y);
                    if (angles.Contains(angle)) continue;
                    visible += 1;
                    angles.Add(angle);
                }
                mostVisible = Math.Max(mostVisible, visible);
            }

            Part1 = mostVisible.ToString();
        }
    }
}