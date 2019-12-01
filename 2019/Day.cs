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
        protected long time;
        protected string part1;
        protected string part2;

        public Day(int day)
        {
            Stopwatch sw = new Stopwatch();
            sw.Start();
            this.day = day;
            Solve();
            sw.Stop();
            time = sw.ElapsedMilliseconds;
            Console.WriteLine($"Day {day} - Time: {time}ms\n- Part 1: {part1}\n- Part 2: {part2}");
        }

        protected abstract void Solve();
        protected IEnumerable<int> Ints { get => File.ReadAllLines(day + ".txt").Select(int.Parse); }
    }
}