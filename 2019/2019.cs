using System;
using System.IO;
using System.Linq;

class Program
{
    static void Main()
    {
        Console.WriteLine(Day1());
    }

    static string Day1()
    {
        int FuelRequired(int mass) => Math.Max(0, mass / 3 - 2);

        int FuelRequiredAccountingForWeightOfFuel(int mass)
        {
            var f = FuelRequired(mass);
            return f > 0 ? f + FuelRequiredAccountingForWeightOfFuel(f) : 0;
        }

        var lines = File.ReadLines("1.txt").Select(m => Convert.ToInt32(m));
        var part1 = lines.Select(FuelRequired).Sum().ToString();
        var part2 = lines.Select(FuelRequiredAccountingForWeightOfFuel).Sum().ToString();
        return part1 + " " + part2;
    }
}