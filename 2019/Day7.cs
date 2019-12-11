using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    class Day7IntCodeComputer
    {
        public bool done = false;
        private int[] memory;
        private int ip = 0;
        private Queue<int> inputs = new Queue<int>();
        public Queue<int> outputs = new Queue<int>();

        public void Flash(int[] memory)
        {
            this.memory = memory.ToArray();
            done = false;
            ip = 0;
            inputs = new Queue<int>();
            outputs = new Queue<int>();
        }

        public bool Run(params int[] inputs)
        {
            foreach (var i in inputs) this.inputs.Enqueue(i);

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
                    if (this.inputs.Count == 0) return false;
                    memory[dest] = this.inputs.Dequeue();
                    ip += 2;
                }
                else if (op == 4)
                {
                    outputs.Enqueue(mode0 == 0 ? memory[memory[ip + 1]] : memory[ip + 1]);
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

            done = true;
            return true;
        }
    }

    public class Day7 : Day
    {
        public Day7() : base(7) { }

        IEnumerable<(int, int, int, int, int)> Permutations(int i)
        {
            for (var aIn = i; aIn < i + 5; aIn++)
            {
                for (var bIn = i; bIn < i + 5; bIn++)
                {
                    if (bIn == aIn) continue;
                    for (var cIn = i; cIn < i + 5; cIn++)
                    {
                        if (cIn == bIn || cIn == aIn) continue;
                        for (var dIn = i; dIn < i + 5; dIn++)
                        {
                            if (dIn == cIn || dIn == bIn || dIn == aIn) continue;
                            for (var eIn = i; eIn < i + 5; eIn++)
                            {
                                if (eIn == dIn || eIn == cIn || eIn == bIn || eIn == aIn) continue;
                                yield return (aIn, bIn, cIn, dIn, eIn);
                            }
                        }
                    }
                }
            }
        }

        protected override void Solve()
        {
            var memory = IntCSV.ToArray();

            {
                var best = int.MinValue;

                foreach (var p in Permutations(0))
                {
                    var c1 = new Day7IntCodeComputer(); c1.Flash(memory);
                    var c2 = new Day7IntCodeComputer(); c2.Flash(memory);
                    var c3 = new Day7IntCodeComputer(); c3.Flash(memory);
                    var c4 = new Day7IntCodeComputer(); c4.Flash(memory);
                    var c5 = new Day7IntCodeComputer(); c5.Flash(memory);

                    c1.Run(p.Item1); c1.Run(0); var a = c1.outputs.Dequeue();
                    c2.Run(p.Item2); c2.Run(a); var b = c2.outputs.Dequeue();
                    c3.Run(p.Item3); c3.Run(b); var c = c3.outputs.Dequeue();
                    c4.Run(p.Item4); c4.Run(c); var d = c4.outputs.Dequeue();
                    c5.Run(p.Item5); c5.Run(d); var e = c5.outputs.Dequeue();

                    if (e > best) best = e;
                }

                Part1 = best.ToString();
            }

            {
                var best = int.MinValue;

                foreach (var p in Permutations(5))
                {
                    var c1 = new Day7IntCodeComputer(); c1.Flash(memory); c1.Run(p.Item1);
                    var c2 = new Day7IntCodeComputer(); c2.Flash(memory); c2.Run(p.Item2);
                    var c3 = new Day7IntCodeComputer(); c3.Flash(memory); c3.Run(p.Item3);
                    var c4 = new Day7IntCodeComputer(); c4.Flash(memory); c4.Run(p.Item4);
                    var c5 = new Day7IntCodeComputer(); c5.Flash(memory); c5.Run(p.Item5);

                    c1.Run(0);

                    while (!c5.done)
                    {
                        while (c1.outputs.Count > 0) c2.Run(c1.outputs.Dequeue());
                        while (c2.outputs.Count > 0) c3.Run(c2.outputs.Dequeue());
                        while (c3.outputs.Count > 0) c4.Run(c3.outputs.Dequeue());
                        while (c4.outputs.Count > 0) c5.Run(c4.outputs.Dequeue());
                        while (c5.outputs.Count > 0)
                        {
                            var output = c5.outputs.Dequeue();
                            if (output > best) best = output;
                            c1.Run(output);
                        }
                    }
                }

                Part2 = best.ToString();
            }
        }
    }
}