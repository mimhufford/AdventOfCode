using System;
using System.Linq;

namespace AoC
{
    public class Day1 : Day
    {
        public Day1() : base(1) { }

        protected override void Solve()
        {
            int FuelRequired(int mass) => Math.Max(0, mass / 3 - 2);

            int FuelRequiredAccountingForWeightOfFuel(int mass)
            {
                var f = FuelRequired(mass);
                return f > 0 ? f + FuelRequiredAccountingForWeightOfFuel(f) : 0;
            }

            Part1 = IntLines.Select(FuelRequired).Sum().ToString();
            Part2 = IntLines.Select(FuelRequiredAccountingForWeightOfFuel).Sum().ToString();
        }
    }
}