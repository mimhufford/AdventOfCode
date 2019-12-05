using System;
using System.Linq;

namespace AoC
{
    public class Day5 : Day
    {
        public Day5() : base(5) { }

        (int op, int[] mode) ParseOpcode(int opcode)
        {
            var op = opcode % 10;
            var mode = (opcode / 100).ToString("D3")
                                     .ToCharArray()
                                     .Reverse()
                                     .Select(c => int.Parse(c.ToString()))
                                     .ToArray();
            return (op, mode);
        }

        protected override void Solve()
        {
            var memory = IntCSV.ToArray();
            var ip = 0;

            while (memory[ip] != 99)
            {
                (var op, var mode) = ParseOpcode(memory[ip]);
                if (op == 1)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode[1] == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p2 + p1;
                    ip += 4;
                }
                else if (op == 2)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode[1] == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p2 * p1;
                    ip += 4;
                }
                else if (op == 3)
                {
                    var dest = memory[ip + 1];
                    memory[dest] = 1;
                    ip += 2;
                }
                else if (op == 4)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    if (p1 != 0) Part1 = p1.ToString();
                    ip += 2;
                }
            }
        }
    }
}