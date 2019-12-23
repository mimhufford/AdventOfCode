using System;
using System.Linq;
using System.Collections.Generic;
using System.Numerics;

namespace AoC
{
    public class Day22 : Day
    {
        public Day22() : base(22) { }

        protected override void Solve()
        {
            var card = 2019L;
            var deck = 10007;

            foreach (string l in Lines)
            {
                if (l[0] == 'c')
                {
                    var cut = (int.Parse(l.Substring(4)) + deck) % deck;
                    card = (card - cut + deck) % deck;
                }
                else if (l[10] == 'i')
                {
                    var inc = int.Parse(l.Substring(20));
                    card = card * inc % deck;
                }
                else
                {
                    card = deck - card - 1;
                }
            }

            Part1 = card.ToString();

            var pos = new BigInteger(2604);

            foreach (string l in Lines.Reverse())
            {
                if (l[0] == 'c')
                {
                    var cut = (int.Parse(l.Substring(4)) + deck) % deck;
                    pos = (pos + cut + deck) % deck;
                }
                else if (l[10] == 'i')
                {
                    var inc = int.Parse(l.Substring(20));
                    pos = (BigInteger.ModPow(inc, deck - 2, deck) * pos) % deck;
                }
                else
                {
                    pos = deck - pos - 1;
                }
            }

            Part2 = pos.ToString();
        }
    }
}