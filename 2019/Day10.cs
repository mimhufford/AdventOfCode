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
                for (int x = 0; x < map[y].Length; x++)
                {
                    if (map[y][x] == '#')
                    {
                        asteroids.Add((x, y));
                    }
                }
            }

            var mostVisible = 0;
            (int x, int y) best = (0, 0);

            foreach (var a in asteroids)
            {
                var visible = 0;
                var angles = new HashSet<double>();

                foreach (var b in asteroids)
                {
                    if (a == b) continue;
                    var angle = Math.Atan2(a.x - b.x, a.y - b.y);
                    if (angles.Contains(angle)) continue;
                    visible += 1;
                    angles.Add(angle);
                }

                if (visible > mostVisible)
                {
                    mostVisible = visible;
                    best = a;
                }
            }

            Part1 = mostVisible.ToString();

            var targets = new List<(int x, int y, double angle, int dist)>();
            foreach (var b in asteroids)
            {
                if (best == b) continue;
                var angle = -Math.Atan2(best.x - b.x, best.y - b.y);
                if (angle < 0) angle += Math.PI * 2;
                var dist = (best.x - b.x) * (best.x - b.x) + (best.y - b.y) * (best.y - b.y);
                var target = (b.x, b.y, angle, dist);
                targets.Add(target);
            }
            targets.Sort((a, b) =>
            {
                if (a.angle < b.angle) return -1;
                if (a.angle > b.angle) return 1;
                if (a.dist < b.dist) return -1;
                return 1;
            });

            var ts = new Queue<(int x, int y, double angle, int dist)>(targets);
            var destroyed = 0;

            while (true)
            {
                var hit = ts.Dequeue();
                if (++destroyed == 200)
                {
                    Part2 = (hit.x * 100 + hit.y).ToString();
                    break;
                }
                while (ts.Peek().angle == hit.angle)
                {
                    ts.Enqueue(ts.Dequeue());
                }
            }
        }
    }
}