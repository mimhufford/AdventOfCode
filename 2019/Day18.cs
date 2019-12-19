using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    class MapInfo
    {
        public HashSet<(int x, int y)> map = new HashSet<(int x, int y)>();
        public Dictionary<char, (int x, int y)> keyToPos = new Dictionary<char, (int x, int y)>();
        public Dictionary<(int x, int y), char> posToKey = new Dictionary<(int x, int y), char>();
        public Dictionary<char, (int x, int y)> doorToPos = new Dictionary<char, (int x, int y)>();
        public Dictionary<(int x, int y), char> posToDoor = new Dictionary<(int x, int y), char>();
        public List<(int x, int y)> bots = new List<(int x, int y)>();
        public Dictionary<char, Dictionary<char, (int dist, List<char> doors)>> routes = new Dictionary<char, Dictionary<char, (int dist, List<char> doors)>>();

        public MapInfo(string[] input)
        {
            for (var y = 0; y < input.Length; y += 1)
            {
                for (var x = 0; x < input[y].Length; x += 1)
                {
                    var tile = input[y][x];
                    switch (tile)
                    {
                        case '#': break;
                        case '.': map.Add((x, y)); break;
                        case '@': bots.Add((x, y)); map.Add((x, y)); break;
                        default:
                            if (char.IsUpper(tile))
                            {
                                doorToPos.Add(tile, (x, y));
                                posToDoor.Add((x, y), tile);
                            }
                            else
                            {
                                keyToPos.Add(tile, (x, y));
                                posToKey.Add((x, y), tile);
                            }
                            map.Add((x, y));
                            break;
                    }
                }
            }

            CalcInfoFor('@', bots[0].x, bots[0].y);
            foreach (var key in keyToPos.Keys) CalcInfoFor(key, keyToPos[key].x, keyToPos[key].y);
        }

        public int CalculateShortestPath()
        {
            void set(ref int n, int bit) { n |= 1 << bit; }
            void clear(ref int n, int bit) { n &= ~(1 << bit); }
            bool check(int n, int bit) => ((n >> bit) & 1) == 1;

            var q = new Queue<(int x, int y, int have, int need, int dist)>();
            var notGot = 0; foreach (var key in keyToPos.Keys) set(ref notGot, key - 'a');
            q.Enqueue((bots[0].x, bots[0].y, 0, notGot, 0));

            var steps = int.MaxValue;
            var seenStates = new Dictionary<(int x, int y, int have), int>();

            while (q.Count > 0)
            {
                var i = q.Dequeue();

                var state = (i.x, i.y, i.have);
                if (seenStates.ContainsKey(state))
                {
                    if (seenStates[state] <= i.dist) continue;
                    else seenStates[state] = i.dist;
                }
                else seenStates.Add(state, i.dist);

                var cur = posToKey.ContainsKey((i.x, i.y)) ? posToKey[(i.x, i.y)] : '@';

                foreach (var key in keyToPos.Keys)
                {
                    // check if we need it
                    if (check(i.need, key - 'a') == false) continue;

                    // we do need it, can we get to it?
                    if (routes[cur][key].doors.Any(d => !check(i.have, char.ToLower(d) - 'a'))) continue;

                    // we can get to it
                    var pos = keyToPos[key];
                    var have = i.have; set(ref have, key - 'a');
                    var need = i.need; clear(ref need, key - 'a');
                    var dist = i.dist + routes[cur][key].dist;

                    if (need == 0) steps = Math.Min(steps, dist);
                    else q.Enqueue((pos.x, pos.y, have, need, dist));
                }
            }

            return steps;
        }

        void CalcInfoFor(char c, int x, int y)
        {
            var q = new Queue<(int x, int y, int distance, List<char> doors)>();
            q.Enqueue((x, y, 0, new List<char>()));
            var m = new Dictionary<(int x, int y), int>();
            while (q.Count > 0)
            {
                var p = q.Dequeue();

                if (posToKey.ContainsKey((p.x, p.y)) && posToKey[(p.x, p.y)] != c)
                {
                    if (!routes.ContainsKey(c)) routes.Add(c, new Dictionary<char, (int, List<char>)>());
                    routes[c].Add(posToKey[(p.x, p.y)], (p.distance, p.doors));
                }

                if (posToDoor.ContainsKey((p.x, p.y)))
                {
                    p.doors.Add(posToDoor[(p.x, p.y)]);
                }

                void Check(int x, int y)
                {
                    if (map.Contains((x, y)) && !m.ContainsKey((x, y)))
                    {
                        m.Add((x, y), p.distance + 1);
                        q.Enqueue((x, y, p.distance + 1, p.doors.ToList()));
                    }
                }

                Check(p.x, p.y - 1);
                Check(p.x, p.y + 1);
                Check(p.x + 1, p.y);
                Check(p.x - 1, p.y);
            }
        }
    }

    public class Day18 : Day
    {
        public Day18() : base(18) { }

        protected override void Solve()
        {
            var input = Lines.ToArray();

            var mi = new MapInfo(input);

            Part1 = mi.CalculateShortestPath().ToString();
        }
    }
}