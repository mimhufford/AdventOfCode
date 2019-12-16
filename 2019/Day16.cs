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

                    for (int j = i; j < input.Length; j++)
                    {
                        var patInd = (j + 1) % patternLength / (i + 1);
                        if (patInd == 1) result[i] += input[j];
                        else if (patInd == 3) result[i] -= input[j];
                    }

                    result[i] = Math.Abs(result[i] % 10);
                }

                return result;
            }

            var signal = Input.ToCharArray().Select(c => (int)(c - '0')).ToArray();

            for (int i = 0; i < 100; i++) signal = FFS(signal);

            Part1 = string.Join("", signal.Take(8));
        }
    }
}