using System;
using System.Linq;
using System.Threading.Tasks;

namespace AoC
{
    public class Day2 : Day
    {
        public Day2() : base(2) { }

        int Run(int noun, int verb, int[] memory)
        {
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
            var memory = IntCSV.ToArray();

            Part1 = Run(12, 2, memory.ToArray()).ToString();

            Parallel.For(0, 100, (int noun) => {
                Parallel.For(0, 100, (int verb) => {
                    if (Part2 == null && Run(noun, verb, memory.ToArray()) == 19690720)
                        Part2 = (100 * noun + verb).ToString();
                });
            });
        }
    }
}