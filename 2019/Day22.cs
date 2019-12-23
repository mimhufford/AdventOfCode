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
            }

            {
                var pos = new BigInteger(2020);
                var rounds = new BigInteger(101741582076661);
                var deck = new BigInteger(119315717514047);
                var a = new BigInteger(1);
                var b = new BigInteger(0);

                foreach (string l in Lines.Reverse())
                {
                    if (l[0] == 'c')
                    {
                        var cut = (int.Parse(l.Substring(4)) + deck) % deck;
                        pos = (pos + cut + deck) % deck;
                        b = b + cut;
                    }
                    else if (l[10] == 'i')
                    {
                        var inc = int.Parse(l.Substring(20));
                        var incInv = BigInteger.ModPow(inc, deck - 2, deck);
                        pos = (incInv * pos) % deck;
                        (a, b) = (a * incInv, b * incInv);
                    }
                    else
                    {
                        pos = deck - pos - 1;
                        (a, b) = (-a, -b + deck - 1);
                    }
                }

                a = a % deck;
                b = b % deck;

                var result = ((2020 * BigInteger.ModPow(a, rounds, deck) + (BigInteger.ModPow(a, rounds, deck) - 1) * b * BigInteger.ModPow(a - 1, deck - 2, deck)) + deck) % deck;
                if (result < 0) result += deck;

                Part2 = result.ToString();
            }
        }
    }
}