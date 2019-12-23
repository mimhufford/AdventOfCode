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
            // Faster way for part 1: work backwards from
            // 2019 and track which position it started at
            // Going to do the slower way first though
            // cos I think I'll need that for part 2...

            var deck = Enumerable.Range(0, 10007).ToList();

            foreach (var l in Lines)
            {
                if (l[0] == 'c')
                {
                    var i = (int.Parse(l.Substring(4)) + 10007) % 10007;
                    deck.AddRange(deck.Take(i));
                    deck = deck.Skip(i).ToList();
                }
                else if (l[10] == 'i')
                {
                    var i = int.Parse(l.Substring(20));
                    var p = 0;
                    var newDeck = new int[10007];
                    for (int c = 0; c < 10007; c++)
                    {
                        newDeck[p] = deck[c];
                        p += i;
                        p %= 10007;
                    }
                    deck = newDeck.ToList();
                }
                else
                {
                    deck.Reverse();
                }
            }

            Part1 = deck.IndexOf(2019).ToString();
        }
    }
}