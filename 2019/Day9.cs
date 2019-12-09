using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class LongIntCodeComputer
    {
        public long[] mem;
        public bool done = false;
        public long ip = 0;
        public long rb = 0;
        public Queue<long> inputs = new Queue<long>();
        public Queue<long> outputs = new Queue<long>();

        public void Flash(long[] memory)
        {
            mem = new long[1024 * 1024];
            for (int i = 0; i < memory.Length; i++) mem[i] = memory[i];
            done = false;
            ip = rb = 0;
            inputs = new Queue<long>();
            outputs = new Queue<long>();
        }

        (long, long, long) Params()
        {
            var mode0 = mem[ip] / 100 % 10;
            var mode1 = mem[ip] / 1000 % 10;
            var mode2 = mem[ip] / 10000 % 10;
            var a = mode0 == 0 ? mem[mem[ip + 1]] : mode0 == 1 ? mem[ip + 1] : mem[rb + mem[ip + 1]];
            var b = mode1 == 0 ? mem[mem[ip + 2]] : mode1 == 1 ? mem[ip + 2] : mem[rb + mem[ip + 2]];
            var c = mode2 == 2 ? rb + mem[ip + 3] : mem[ip + 3];
            return (a, b, c);
        }

        public bool Run(params int[] inputs)
        {
            foreach (var i in inputs) this.inputs.Enqueue(i);

            while (mem[ip] != 99)
            {
                var op = mem[ip] % 10;
                (var a, var b, var c) = Params();

                if (op == 1)
                {
                    mem[c] = b + a;
                    ip += 4;
                }
                else if (op == 2)
                {
                    mem[c] = b * a;
                    ip += 4;
                }
                else if (op == 3)
                {
                    var m = mem[ip] / 100 % 10;
                    if (m == 0) a = mem[ip + 1];
                    else if (m == 1) a = ip + 1;
                    else if (m == 2) a = rb + mem[ip + 1];
                    if (this.inputs.Count == 0) return false;
                    mem[a] = this.inputs.Dequeue();
                    ip += 2;
                }
                else if (op == 4)
                {
                    outputs.Enqueue(a);
                    ip += 2;
                }
                else if (op == 5)
                {
                    ip = a != 0 ? b : ip + 3;
                }
                else if (op == 6)
                {
                    ip = a == 0 ? b : ip + 3;
                }
                else if (op == 7)
                {
                    mem[c] = a < b ? 1 : 0;
                    ip += 4;
                }
                else if (op == 8)
                {
                    mem[c] = a == b ? 1 : 0;
                    ip += 4;
                }
                else if (op == 9)
                {
                    rb += a;
                    ip += 2;
                }
            }

            done = true;
            return true;
        }
    }

    public class Day9 : Day
    {
        public Day9() : base(9) { }

        protected override void Solve()
        {
            var memory = LongCSV.ToArray();
            var computer = new LongIntCodeComputer();

            computer.Flash(memory);
            computer.Run(1);
            Part1 = computer.outputs.Dequeue().ToString();

            computer.Flash(memory);
            computer.Run(2);
            Part2 = computer.outputs.Dequeue().ToString();
        }
    }
}