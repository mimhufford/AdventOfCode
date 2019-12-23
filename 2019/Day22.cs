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
            long Cut(long card, long deck, long cut) => (card - cut + deck) % deck;
            long Inc(long card, long deck, long inc) => (card * inc % deck);
            long Rev(long card, long deck) => (deck - card - 1);

            {
                // Part 1
                var card = 2019L;
                var deck = 10007;

                foreach (string l in Lines)
                {
                    if (l[0] == 'c')
                        card = Cut(card, deck, (int.Parse(l.Substring(4)) + deck) % deck);
                    else if (l[10] == 'i')
                        card = Inc(card, deck, int.Parse(l.Substring(20)));
                    else
                        card = Rev(card, deck);
                }

                Part1 = card.ToString();
            }
        }
    }
}