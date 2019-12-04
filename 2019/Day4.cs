using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace AoC
{
    public class Day4 : Day
    {
        public Day4() : base(4) { }

        protected override void Solve()
        {
            int d1(int i) => i / 100000 % 10;
            int d2(int i) => i / 10000 % 10;
            int d3(int i) => i / 1000 % 10;
            int d4(int i) => i / 100 % 10;
            int d5(int i) => i / 10 % 10;
            int d6(int i) => i / 1 % 10;

            int ascend(int i)
            {
                var n1 = d1(i); var n2 = d2(i); var n3 = d3(i);
                var n4 = d4(i); var n5 = d5(i); var n6 = d6(i);
                if (n2 < n1) n6 = n5 = n4 = n3 = n2 = n1;
                else if (n3 < n2) n6 = n5 = n4 = n3 = n2;
                else if (n4 < n3) n6 = n5 = n4 = n3;
                else if (n5 < n4) n6 = n5 = n4;
                else if (n6 < n5) n6 = n5;
                return n1 * 100000 + n2 * 10000 + n3 * 1000 + n4 * 100 + n5 * 10 + n6;
            }

            bool hasDup(int i)
            {
                var n1 = d1(i); var n2 = d2(i); var n3 = d3(i);
                var n4 = d4(i); var n5 = d5(i); var n6 = d6(i);
                return n1 == n2 || n2 == n3 | n3 == n4 || n4 == n5 || n5 == n6;
            }

            int next(int i)
            {
                i++;
                i = ascend(i);
                if (!hasDup(i)) return next(i);
                return i;
            }

            var range = Input.Split('-').Select(int.Parse);
            var min = range.First();
            var max = range.Last();

            var count = hasDup(min) ? 1 : 0;
            for (var i = next(min); i < max; i = next(i)) count++;

            Part1 = count.ToString();
        }
    }
}