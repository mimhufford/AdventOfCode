using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day11 : Day
    {
        public Day11() : base(11) { }

        protected override void Solve()
        {
            const int U = 0;
            const int R = 1;
            const int D = 2;
            const int L = 3;
            var x = 0;
            var y = 0;
            var dir = U;
            var visited = new Dictionary<(int x, int y), int>();
            var brain = new LongIntCodeComputer();
            var memory = LongCSV.ToArray();
            brain.Flash(memory);

            while (!brain.done)
            {
                if (!visited.ContainsKey((x, y))) visited.Add((x, y), 0);
                brain.Run(visited[(x, y)]);
                visited[(x, y)] = (int)brain.outputs.Dequeue();
                dir += brain.outputs.Dequeue() == 0 ? -1 : 1;
                dir = (dir + 4) % 4;
                x += dir == U ? 1 : dir == D ? -1 : 0;
                y += dir == R ? 1 : dir == L ? -1 : 0;
            }

            Part1 = visited.Count.ToString();

            x = 0; y = 0; dir = U; visited.Clear(); brain.Flash(memory);

            while (!brain.done)
            {
                if (!visited.ContainsKey((x, y))) visited.Add((x, y), 1);
                brain.Run(visited[(x, y)]);
                visited[(x, y)] = (int)brain.outputs.Dequeue();
                dir += brain.outputs.Dequeue() == 0 ? -1 : 1;
                dir = (dir + 4) % 4;
                x += dir == U ? 1 : dir == D ? -1 : 0;
                y += dir == R ? 1 : dir == L ? -1 : 0;
            }

            var minX = visited.Keys.Min(coord => coord.x);
            var minY = visited.Keys.Min(coord => coord.y);

#if false
            Console.Clear();
            foreach (((int xx, int yy), int c) in visited)
            {
                Console.SetCursorPosition(yy - minY, xx - minX);
                Console.Write(c == 0 ? ' ' : '#');
            }
            Console.ReadLine();
#endif
            Part2 = "ZLEBKJRA"; // hardcoded for nicer output, generated using above
        }
    }
}