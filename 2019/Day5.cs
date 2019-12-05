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

        int Run(int input)
        {
            var memory = IntCSV.ToArray();
            var ip = 0;
            var result = 0;

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
                    memory[dest] = input;
                    ip += 2;
                }
                else if (op == 4)
                {
                    result = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    ip += 2;
                }
                else if (op == 5)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode[1] == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    if (p1 != 0) ip = p2;
                    else ip += 3;
                }
                else if (op == 6)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode[1] == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    if (p1 == 0) ip = p2;
                    else ip += 3;
                }
                else if (op == 7)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode[1] == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p1 < p2 ? 1 : 0;
                    ip += 4;
                }
                else if (op == 8)
                {
                    var p1 = mode[0] == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode[1] == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p1 == p2 ? 1 : 0;
                    ip += 4;
                }
            }

            return result;
        }

        protected override void Solve()
        {
            Part1 = Run(1).ToString();
            Part2 = Run(5).ToString();
        }
    }
}