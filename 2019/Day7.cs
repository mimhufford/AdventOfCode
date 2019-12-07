using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day7 : Day
    {
        public Day7() : base(7) { }

        int Run(int[] memory, Queue<int> input)
        {
            var ip = 0;
            var result = 0;

            while (memory[ip] != 99)
            {
                var op = memory[ip] % 10;
                var mode0 = (memory[ip] / 100) % 10;
                var mode1 = memory[ip] / 1000;

                if (op == 1)
                {
                    var p1 = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode1 == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p2 + p1;
                    ip += 4;
                }
                else if (op == 2)
                {
                    var p1 = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode1 == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p2 * p1;
                    ip += 4;
                }
                else if (op == 3)
                {
                    var dest = memory[ip + 1];
                    memory[dest] = input.Dequeue();
                    ip += 2;
                }
                else if (op == 4)
                {
                    result = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    ip += 2;
                }
                else if (op == 5)
                {
                    var p1 = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode1 == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    if (p1 != 0) ip = p2;
                    else ip += 3;
                }
                else if (op == 6)
                {
                    var p1 = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode1 == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    if (p1 == 0) ip = p2;
                    else ip += 3;
                }
                else if (op == 7)
                {
                    var p1 = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode1 == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p1 < p2 ? 1 : 0;
                    ip += 4;
                }
                else if (op == 8)
                {
                    var p1 = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    var p2 = mode1 == 0 ? memory[memory[ip + 2]] : memory[ip + 2];
                    var dest = memory[ip + 3];
                    memory[dest] = p1 == p2 ? 1 : 0;
                    ip += 4;
                }
            }

            return result;
        }

        protected override void Solve()
        {
            var memory = IntCSV.ToArray();

            var best = int.MinValue;

            for (var aIn = 0; aIn < 5; aIn++)
            {
                for (var bIn = 0; bIn < 5; bIn++)
                {
                    if (bIn == aIn) continue;
                    for (var cIn = 0; cIn < 5; cIn++)
                    {
                        if (cIn == bIn || cIn == aIn) continue;
                        for (var dIn = 0; dIn < 5; dIn++)
                        {
                            if (dIn == cIn || dIn == bIn || dIn == aIn) continue;
                            for (var eIn = 0; eIn < 5; eIn++)
                            {
                                if (eIn == dIn || eIn == cIn || eIn == bIn || eIn == aIn) continue;

                                var a = Run(memory.ToArray(), new Queue<int>(new int[] { aIn, 0 }));
                                var b = Run(memory.ToArray(), new Queue<int>(new int[] { bIn, a }));
                                var c = Run(memory.ToArray(), new Queue<int>(new int[] { cIn, b }));
                                var d = Run(memory.ToArray(), new Queue<int>(new int[] { dIn, c }));
                                var e = Run(memory.ToArray(), new Queue<int>(new int[] { eIn, d }));

                                if (e > best) best = e;
                            }
                        }
                    }
                }
            }

            Part1 = best.ToString();
        }
    }
}