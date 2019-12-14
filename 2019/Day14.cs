using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day14 : Day
    {
        public Day14() : base(14) { }

        protected override void Solve()
        {
            var recipes = new Dictionary<string, (int yield, List<(string name, int amt)> ingredients)>();

            foreach (var i in Lines.Select(l => l.Split(" => ")).Select(p => (p[0], p[1].Split(' '))))
            {
                var key = i.Item2[1];
                var yield = int.Parse(i.Item2[0]);
                var val = new List<(string name, int amt)>();
                foreach (var j in i.Item1.Trim().Split(", ").Select(p => p.Split(' ')))
                    val.Add((j[1], int.Parse(j[0])));
                recipes.Add(key, (yield, val));
            }

            var used = 0;
            var have = new Dictionary<string, int>();
            var need = new Queue<(string name, int amt)>();

            need.Enqueue(("FUEL", 1));

            while (need.Count > 0)
            {
                (var name, var amt) = need.Dequeue();

                if (have.ContainsKey(name))
                {
                    if (have[name] >= amt)
                    {
                        // we have everything we need so move on
                        have[name] -= amt;
                        continue;
                    }
                    else
                    {
                        // we have some, so use that up first
                        amt -= have[name];
                        have[name] = 0;
                    }
                }

                (var yield, var ingredients) = recipes[name];

                // make sure we're requesting enough
                var multiplier = 1; while (yield * multiplier < amt) multiplier += 1;

                if (yield * multiplier > amt)
                {
                    // add surplus to our reserves
                    if (!have.ContainsKey(name)) have[name] = 0;
                    have[name] += yield * multiplier - amt;
                }

                foreach (var ingredient in ingredients)
                {
                    if (ingredient.name == "ORE")
                    {
                        // count raw ingredients
                        used += ingredient.amt * multiplier;
                    }
                    else
                    {
                        // add the components to the queue
                        need.Enqueue((ingredient.name, ingredient.amt * multiplier));
                    }
                }
            }

            Part1 = used.ToString();
        }
    }
}