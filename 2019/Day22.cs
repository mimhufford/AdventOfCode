using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day22 : Day
    {
        public Day22() : base(22) { }

        protected override void Solve()
        {
            var card = 2019;

            foreach (string l in Lines)
            {
                if (l[0] == 'c')
                {
                    var i = (int.Parse(l.Substring(4)) + 10007) % 10007;
                    card -= i;
                    card += 10007;
                    card %= 10007;
                }
                else if (l[10] == 'i')
                {
                    var i = int.Parse(l.Substring(20));
                    card = card * i % 10007;
                }
                else
                {
                    card = 10007 - card - 1;
                }
            }

            Part1 = card.ToString();
        }
    }
}