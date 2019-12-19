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
            void FFS(int[] signal)
            {
                for (int i = 0; i < signal.Length; i++)
                {
                    var patternLength = (i + 1) * 4;
                    var orig = signal[i];
                    var j = i;

                    while (j < signal.Length)
                    {
                        var run = (j + 1) % patternLength / (i + 1);
                        var end = Math.Min(j + i, signal.Length - 1);
                        if (run == 1) // add on the next run
                            for (int k = j; k <= end; k++) signal[i] += signal[k];
                        else if (run == 3) // subtract the next run
                            for (int k = j; k <= end; k++) signal[i] -= signal[k];
                        j += i + 1; // jump to the next run
                    }

                    signal[i] = Math.Abs((signal[i] - orig) % 10);
                }
            }

            void LastHalf(int[] signal)
            {
                for (int i = signal.Length - 2; i >= 0; i--)
                {
                    signal[i] = (signal[i] + signal[i + 1]) % 10;
                }
            }

            var input = Input;
            var signal = new int[input.Length];
            for (int i = 0; i < input.Length; i++) signal[i] = (int)(input[i] - '0');

            var p1 = signal.ToArray();
            for (int i = 0; i < 100; i++) FFS(p1);
            Part1 = string.Join("", p1.Take(8));

            var offset = int.Parse(string.Join("", signal.Take(7)));
            var repeats = 10000 - offset / signal.Length;
            offset %= signal.Length;
            var p2 = new List<int>(signal.Length * repeats);
            for (int i = 0; i < repeats; i++) p2.AddRange(signal);
            var p2a = p2.Skip(offset).ToArray();
            for (int i = 0; i < 100; i++) LastHalf(p2a);
            Part2 = string.Join("", p2a.Take(8));
        }
    }
}