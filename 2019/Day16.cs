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
                        var patInd = (j + 1) % patternLength / (i + 1);
                        if (patInd == 1) // add on the next run
                            for (int a = j; a <= j + i && a < signal.Length; a++)
                                signal[i] += signal[a];
                        else if (patInd == 3) // subtract the next run
                            for (int a = j; a <= j + i && a < signal.Length; a++)
                                signal[i] -= signal[a];
                        j += i + 1; // jump to the next run
                    }

                    signal[i] = Math.Abs((signal[i] - orig) % 10);
                }
            }

            var signal = Input.ToCharArray().Select(c => (int)(c - '0')).ToArray();

            for (int i = 0; i < 100; i++) FFS(signal);

            Part1 = string.Join("", signal.Take(8));
        }
    }
}