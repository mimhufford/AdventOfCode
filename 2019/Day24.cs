using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day24 : Day
    {
        public Day24() : base(24) { }

        int neighbours(int map, int x, int y)
        {
            int result = 0;
            if (bug(map, x + 1, y + 0)) result += 1;
            if (bug(map, x + 0, y + 1)) result += 1;
            if (bug(map, x - 1, y + 0)) result += 1;
            if (bug(map, x + 0, y - 1)) result += 1;
            return result;
        }

        bool bug(int map, int x, int y)
        {
            if (x < 0) return false;
            if (x > 4) return false;
            if (y < 0) return false;
            if (y > 4) return false;
            int bit = y * 5 + x;
            return ((map >> bit) & 1) == 1;
        }

        int Step(int map)
        {
            var result = 0;

            for (int y = 0; y < 5; y++)
            {
                for (int x = 0; x < 5; x++)
                {
                    int i = y * 5 + x;

                    var n = neighbours(map, x, y);

                    if (bug(map, x, y))
                    {
                        if (n == 1)
                        {
                            result |= 1 << i;
                        }
                    }
                    else
                    {
                        if (n == 1 || n == 2)
                        {
                            result |= 1 << i;
                        }
                    }
                }
            }

            return result;
        }

        int neighbours(int level, Dictionary<int, int> map, int x, int y)
        {
            int result = 0;

            if (x == 1 && y == 2)
            {
                if (bug(level + 1, map, 0, 0)) result += 1;
                if (bug(level + 1, map, 0, 1)) result += 1;
                if (bug(level + 1, map, 0, 2)) result += 1;
                if (bug(level + 1, map, 0, 3)) result += 1;
                if (bug(level + 1, map, 0, 4)) result += 1;
            }
            else if (bug(level, map, x + 1, y)) result += 1;

            if (x == 3 && y == 2)
            {
                if (bug(level + 1, map, 4, 0)) result += 1;
                if (bug(level + 1, map, 4, 1)) result += 1;
                if (bug(level + 1, map, 4, 2)) result += 1;
                if (bug(level + 1, map, 4, 3)) result += 1;
                if (bug(level + 1, map, 4, 4)) result += 1;
            }
            else if (bug(level, map, x - 1, y)) result += 1;

            if (y == 1 && x == 2)
            {
                if (bug(level + 1, map, 0, 0)) result += 1;
                if (bug(level + 1, map, 1, 0)) result += 1;
                if (bug(level + 1, map, 2, 0)) result += 1;
                if (bug(level + 1, map, 3, 0)) result += 1;
                if (bug(level + 1, map, 4, 0)) result += 1;
            }
            else if (bug(level, map, x, y + 1)) result += 1;

            if (y == 3 && x == 2)
            {
                if (bug(level + 1, map, 0, 4)) result += 1;
                if (bug(level + 1, map, 1, 4)) result += 1;
                if (bug(level + 1, map, 2, 4)) result += 1;
                if (bug(level + 1, map, 3, 4)) result += 1;
                if (bug(level + 1, map, 4, 4)) result += 1;
            }
            else if (bug(level, map, x, y - 1)) result += 1;

            return result;
        }

        bool bug(int level, Dictionary<int, int> map, int x, int y)
        {
            if (x < 0) return bug(level - 1, map, 1, 2);
            if (x > 4) return bug(level - 1, map, 3, 2);
            if (y < 0) return bug(level - 1, map, 2, 1);
            if (y > 4) return bug(level - 1, map, 2, 3);
            int bit = y * 5 + x;
            if (!map.ContainsKey(level)) return false;
            return ((map[level] >> bit) & 1) == 1;
        }

        Dictionary<int, int> Step(Dictionary<int, int> map)
        {
            var result = new Dictionary<int, int>();
            foreach (var level in map.Keys) result.Add(level, 0);

            foreach (var level in map.Keys)
            {
                for (int y = 0; y < 5; y++)
                {
                    for (int x = 0; x < 5; x++)
                    {
                        if (x == 2 && y == 2) continue;

                        var i = y * 5 + x;
                        var n = neighbours(level, map, x, y);

                        if (bug(level, map, x, y))
                        {
                            if (n == 1) result[level] |= 1 << i;
                        }
                        else
                        {
                            if (n == 1 || n == 2) result[level] |= 1 << i;
                        }
                    }
                }
            }

            return result;
        }


        protected override void Solve()
        {
            var initialMap = 0;

            {
                var i = 0;

                foreach (var row in Lines)
                {
                    foreach (var cell in row)
                    {
                        if (cell == '#') initialMap |= 1 << i;
                        i += 1;
                    }
                }
            }

            var seen = new HashSet<int>() { initialMap };

            var map = initialMap;
            while (true)
            {
                map = Step(map);

                if (seen.Contains(map))
                {
                    Part1 = map.ToString();
                    break;
                }

                seen.Add(map);
            }

            var recursiveMap = new Dictionary<int, int>();
            for (int i = -100; i <= 100; i += 1) recursiveMap.Add(i, 0);
            recursiveMap[0] = initialMap;

            for (int i = 0; i < 200; i++) recursiveMap = Step(recursiveMap);

            int count = 0;

            foreach (var layer in recursiveMap.Values)
            {
                int ml = layer;
                while (ml > 0)
                {
                    count += ml & 1;
                    ml >>= 1;
                }
            }

            Part2 = count.ToString();
        }
    }
}