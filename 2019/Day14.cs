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
            var recipes = new Dictionary<string, (long yield, List<(string name, long amt)> ingredients)>();

            foreach (var i in Lines.Select(l => l.Split(" => ")).Select(p => (p[0], p[1].Split(' '))))
            {
                var key = i.Item2[1];
                var yield = long.Parse(i.Item2[0]);
                var val = new List<(string name, long amt)>();
                foreach (var j in i.Item1.Trim().Split(", ").Select(p => p.Split(' ')))
                    val.Add((j[1], long.Parse(j[0])));
                recipes.Add(key, (yield, val));
            }

            long OreRequiredFor(long amount)
            {
                var ore = 0L;
                var have = new Dictionary<string, long>();
                var need = new Dictionary<string, long>();

                need.Add("FUEL", amount);

                while (need.Count > 0)
                {
                    var name = need.Keys.First();
                    var amt = need[name];
                    need.Remove(name);

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
                    var multiplier = (amt + yield - 1) / yield;

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
                            ore += ingredient.amt * multiplier;
                        }
                        else
                        {
                            // add the components to the queue
                            if (!need.ContainsKey(ingredient.name)) need[ingredient.name] = 0;
                            need[ingredient.name] += ingredient.amt * multiplier;
                        }
                    }
                }

                return ore;
            }

            Part1 = OreRequiredFor(1).ToString();

            var lower = 1L;
            var upper = 1000000000000L;

            while (true)
            {
                var mid = (upper + lower) / 2;
                if (mid == lower || mid == upper) break;
                if (OreRequiredFor(mid) < 1000000000000) lower = mid;
                else upper = mid;
            }

            Part2 = lower.ToString();
        }
    }
}