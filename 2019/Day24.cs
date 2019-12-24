using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day24 : Day
    {
        public Day24() : base(24) { }

        protected override void Solve()
        {
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

            var map = 0;

            {
                var i = 0;

                foreach (var row in Lines)
                {
                    foreach (var cell in row)
                    {
                        if (cell == '#') map |= 1 << i;
                        i += 1;
                    }
                }
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

            var seen = new HashSet<int>() { map };

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
        }
    }
}