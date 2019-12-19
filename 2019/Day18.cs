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
            (int x, int y) start = (0, 0);

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
                        case '@': start = (x, y); map.Add((x, y)); break;
                        default:
                            if (tile >= 'A' && tile <= 'Z') doors.Add(tile, (x, y));
                            else keys.Add(tile, (x, y));
                            map.Add((x, y));
                            break;
                    }
                }
            }

            var q = new Queue<(int x, int y, int distance)>();
            q.Enqueue((start.x, start.y, 0));
            var m = new Dictionary<(int x, int y), int>();
            while (q.Count > 0)
            {
                var p = q.Dequeue();

                (int x, int y) e = (p.x + 1, p.y);
                (int x, int y) w = (p.x - 1, p.y);
                (int x, int y) n = (p.x, p.y - 1);
                (int x, int y) s = (p.x, p.y + 1);

                if (map.Contains(n) && !m.ContainsKey(n))
                {
                    m.Add(n, p.distance + 1);
                    q.Enqueue((n.x, n.y, p.distance + 1));
                }
                if (map.Contains(e) && !m.ContainsKey(e))
                {
                    m.Add(e, p.distance + 1);
                    q.Enqueue((e.x, e.y, p.distance + 1));
                }
                if (map.Contains(s) && !m.ContainsKey(s))
                {
                    m.Add(s, p.distance + 1);
                    q.Enqueue((s.x, s.y, p.distance + 1));
                }
                if (map.Contains(w) && !m.ContainsKey(w))
                {
                    m.Add(w, p.distance + 1);
                    q.Enqueue((w.x, w.y, p.distance + 1));
                }
            }

        }
    }
}