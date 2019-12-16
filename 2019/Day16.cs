using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day16 : Day
    {
        public Day16() : base(16) { }

        protected override void Solve()
        {
            int[] FFS(int[] input)
            {
                var result = new int[input.Length];

                for (int i = 0; i < input.Length; i++)
                {
                    var patternLength = (i + 1) * 4;

                    for (int j = 0; j < input.Length; j++)
                    {
                        var pa = (j + 1) % patternLength / (i + 1);
                        var multiple = pa == 2 ? 0 : pa == 3 ? -1 : pa;
                        var a = input[j];
                        var b = multiple;
                        result[i] += (int)(a * b);
                    }

                    result[i] %= 10;
                    result[i] = Math.Abs(result[i]);
                }

                return result;
            }

            var signal = Input.ToCharArray().Select(c => (int)(c - '0')).ToArray();

            for (int i = 0; i < 100; i++) signal = FFS(signal);

            Part1 = string.Join("", signal.Take(8));
        }
    }
}