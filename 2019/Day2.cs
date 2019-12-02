using System;
using System.Linq;

namespace AoC
{
    public class Day2 : Day
    {
        public Day2() : base(2) { }

        int Run(int noun, int verb)
        {
            var memory = IntCSV.ToArray();
            var ip = 0;

            memory[1] = noun;
            memory[2] = verb;

            while (memory[ip] != 99)
            {
                if (memory[ip] == 1)
                    memory[memory[ip + 3]] = memory[memory[ip + 1]] + memory[memory[ip + 2]];
                else if (memory[ip] == 2)
                    memory[memory[ip + 3]] = memory[memory[ip + 1]] * memory[memory[ip + 2]];

                ip += 4;
            }

            return memory[0];
        }

        protected override void Solve()
        {
            Part1 = Run(12, 2).ToString();

            for (int noun = 0; noun < 100; noun++)
            {
                for (int verb = 0; verb < 100; verb++)
                {
                    if (Run(noun, verb) == 19690720)
                    {
                        Part2 = (100 * noun + verb).ToString();
                        noun = verb = 100; // break loops
                    }
                }
            }
        }
    }
}