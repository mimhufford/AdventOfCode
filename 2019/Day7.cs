using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class IntCodeComputer
    {
        private int[] memory;
        private int result;
        private int ip = 0;
        private Queue<int> inputs = new Queue<int>();

        public void Flash(int[] memory)
        {
            this.memory = memory.ToArray();
            ip = 0;
            inputs = new Queue<int>();
        }

        public (int result, bool complete) Run(int input)
        {
            inputs.Enqueue(input);

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
                    if (inputs.Count == 0) return (result, false);
                    memory[dest] = inputs.Dequeue();
                    ip += 2;
                }
                else if (op == 4)
                {
                    result = mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1];
                    ip += 2;
                    return (result, false);
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
            return (result, true);
        }
    }

    public class Day7 : Day
    {
        public Day7() : base(7) { }

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

                                var c1 = new IntCodeComputer(); c1.Flash(memory); c1.Run(aIn);
                                var c2 = new IntCodeComputer(); c2.Flash(memory); c2.Run(bIn);
                                var c3 = new IntCodeComputer(); c3.Flash(memory); c3.Run(cIn);
                                var c4 = new IntCodeComputer(); c4.Flash(memory); c4.Run(dIn);
                                var c5 = new IntCodeComputer(); c5.Flash(memory); c5.Run(eIn);

                                var a = 0; while (true) { var r = c1.Run(0); a = r.result; if (r.complete) break; }
                                var b = 0; while (true) { var r = c2.Run(a); b = r.result; if (r.complete) break; }
                                var c = 0; while (true) { var r = c3.Run(b); c = r.result; if (r.complete) break; }
                                var d = 0; while (true) { var r = c4.Run(c); d = r.result; if (r.complete) break; }
                                var e = 0; while (true) { var r = c5.Run(d); e = r.result; if (r.complete) break; }

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