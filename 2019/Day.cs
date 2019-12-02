using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace AoC
{
    public abstract class Day
    {
        private int day;

        protected string Part1;
        protected string Part2;

        public Day(int day)
        {
            this.day = day;
            Stopwatch sw = new Stopwatch();
            sw.Start();
            Solve();
            sw.Stop();
            Console.WriteLine($"Day {day} - Time: {sw.ElapsedMilliseconds}ms\n- Part 1: {Part1}\n- Part 2: {Part2}");
        }

        protected abstract void Solve();

        // Helper Utils
        protected IEnumerable<int> IntLines { get => File.ReadAllLines(day + ".txt").Select(int.Parse); }
        protected IEnumerable<int> IntCSV { get => File.ReadAllText(day + ".txt").Split(',').Select(int.Parse); }
    }
}