using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace AoC
{
    public abstract class Day
    {
        private string file;

        protected string Part1;
        protected string Part2;

        public Day(int day)
        {
            file = $"input/{day}.txt";
            Stopwatch sw = new Stopwatch();
            sw.Start();
            Solve();
            sw.Stop();
            Console.WriteLine($"Day {day} - Time: {sw.ElapsedMilliseconds}ms\n- Part 1: {Part1}\n- Part 2: {Part2}");
        }

        protected abstract void Solve();

        // Helper Utils
        protected IEnumerable<int> IntLines { get => File.ReadAllLines(file).Select(int.Parse); }
        protected IEnumerable<int> IntCSV { get => File.ReadAllText(file).Split(',').Select(int.Parse); }
        protected IEnumerable<string> Lines { get => File.ReadAllLines(file); }
        protected string Input { get => File.ReadAllText(file); }
    }
}