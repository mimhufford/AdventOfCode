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
        public (int x, int y) bot;
        public Dictionary<char, Dictionary<char, (int dist, int doors)>> routes = new Dictionary<char, Dictionary<char, (int dist, int doors)>>();

        public MapInfo(char[][] input)
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
                        case '@': bot = (x, y); map.Add((x, y)); break;
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

            CalcInfoFor('@', bot.x, bot.y);
            foreach (var key in keyToPos.Keys) CalcInfoFor(key, keyToPos[key].x, keyToPos[key].y);
            posToKey.Add((bot.x, bot.y), '@');
        }

        void set(ref int n, int bit) { n |= 1 << bit; }
        void clear(ref int n, int bit) { n &= ~(1 << bit); }
        bool check(int n, int bit) => ((n >> bit) & 1) == 1;

        public int CalculateShortestPath()
        {
            var keys = int.MaxValue; foreach (var key in keyToPos.Keys) clear(ref keys, key - 'a');
            var q = new Queue<(int x, int y, int keys, int dist)>();
            q.Enqueue((bot.x, bot.y, keys, 0));

            var steps = int.MaxValue;
            var seenStates = new Dictionary<long, int>();

            while (q.Count > 0)
            {
                var i = q.Dequeue();

                var state = ((long)i.x << 50) + ((long)i.y << 40) + i.keys;
                if (seenStates.ContainsKey(state))
                {
                    if (seenStates[state] <= i.dist) continue;
                    else seenStates[state] = i.dist;
                }
                else seenStates.Add(state, i.dist);

                var cur = posToKey[(i.x, i.y)];

                foreach (var key in routes[cur].Keys)
                {
                    // check if we need it
                    if (check(i.keys, key - 'a') == true) continue;

                    // we do need it, can we get to it?
                    var required = routes[cur][key].doors;
                    if ((required & i.keys) != required) continue;

                    // we can get to it
                    var pos = keyToPos[key];
                    var nKys = i.keys; set(ref nKys, key - 'a');
                    var dist = i.dist + routes[cur][key].dist;

                    if (nKys == int.MaxValue) steps = Math.Min(steps, dist);
                    else q.Enqueue((pos.x, pos.y, nKys, dist));
                }
            }

            return steps;
        }

        void CalcInfoFor(char c, int x, int y)
        {
            var numDoors = 0;
            var q = new Queue<(int x, int y, int distance, int doors)>();
            q.Enqueue((x, y, 0, 0));
            var m = new Dictionary<(int x, int y), int>();
            while (q.Count > 0)
            {
                var p = q.Dequeue();
                var pos = (p.x, p.y);

                if (posToKey.ContainsKey(pos) && posToKey[pos] != c)
                {
                    if (!routes.ContainsKey(c)) routes.Add(c, new Dictionary<char, (int, int)>());
                    routes[c].Add(posToKey[pos], (p.distance, p.doors));
                }

                if (posToDoor.ContainsKey(pos) && keyToPos.ContainsKey(char.ToLower(posToDoor[pos])))
                {
                    set(ref p.doors, posToDoor[pos] - 'A');
                    if (numDoors++ == 20) break;
                }

                void Check(int x, int y)
                {
                    if (map.Contains((x, y)) && !m.ContainsKey((x, y)))
                    {
                        m.Add((x, y), p.distance + 1);
                        q.Enqueue((x, y, p.distance + 1, p.doors));
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
            var input = Lines.Select(l => l.ToCharArray()).ToArray();

            var mi1 = new MapInfo(input);
            Part1 = mi1.CalculateShortestPath().ToString();

            input[mi1.bot.x + 0][mi1.bot.y + 0] = '#';
            input[mi1.bot.x + 1][mi1.bot.y + 0] = '#';
            input[mi1.bot.x - 1][mi1.bot.y + 0] = '#';
            input[mi1.bot.x + 0][mi1.bot.y + 1] = '#';
            input[mi1.bot.x + 0][mi1.bot.y - 1] = '#';
            input[mi1.bot.x + 1][mi1.bot.y + 1] = '@';
            input[mi1.bot.x - 1][mi1.bot.y + 1] = '@';
            input[mi1.bot.x + 1][mi1.bot.y - 1] = '@';
            input[mi1.bot.x - 1][mi1.bot.y - 1] = '@';

            var q1 = input.Take(input.Count() / 2).Select(row => row.Take(row.Count() / 2).ToArray()).ToArray();
            var q2 = input.Skip(input.Count() / 2).Select(row => row.Take(row.Count() / 2).ToArray()).ToArray();
            var q3 = input.Take(input.Count() / 2).Select(row => row.Skip(row.Count() / 2).ToArray()).ToArray();
            var q4 = input.Skip(input.Count() / 2).Select(row => row.Skip(row.Count() / 2).ToArray()).ToArray();
            var q1c = new MapInfo(q1).CalculateShortestPath();
            var q2c = new MapInfo(q2).CalculateShortestPath();
            var q3c = new MapInfo(q3).CalculateShortestPath();
            var q4c = new MapInfo(q4).CalculateShortestPath();
            Part2 = (q1c + q2c + q3c + q4c).ToString();
        }
    }
}