using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    class BeamComputer
    {
        public int[] mem;
        public int ip = 0;
        public int rb = 0;
        public Queue<int> inputs = new Queue<int>();

        public void Flash(int[] memory)
        {
            mem = new int[22222];
            for (int i = 0; i < memory.Length; i++) mem[i] = memory[i];
            ip = rb = 0;
            inputs = new Queue<int>();
        }

        (int, int, int) Params()
        {
            var mode0 = mem[ip] / 100 % 10;
            var mode1 = mem[ip] / 1000 % 10;
            var mode2 = mem[ip] / 10000 % 10;
            var a = mode0 == 0 ? mem[mem[ip + 1]] : mode0 == 1 ? mem[ip + 1] : mem[rb + mem[ip + 1]];
            var b = mode1 == 0 ? mem[mem[ip + 2]] : mode1 == 1 ? mem[ip + 2] : mem[rb + mem[ip + 2]];
            var c = mode2 == 2 ? rb + mem[ip + 3] : mem[ip + 3];
            return (a, b, c);
        }

        public int Run(params int[] inputs)
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
                    mem[a] = this.inputs.Dequeue();
                    ip += 2;
                }
                else if (op == 4)
                {
                    return a;
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

            return -1;
        }
    }

    public class Day19 : Day
    {
        public Day19() : base(19) { }

        protected override void Solve()
        {
            var c = new BeamComputer();
            var mem = IntCSV.ToArray();

            var beamed = 0L;

            {
                var xMin = 0; // so we don't have to search from 0 every time
                var minLength = 0; // so we can skip ones we know are in the ray

                for (int y = 0; y < 50; y++)
                {
                    for (int x = xMin; x < 50; x++)
                    {
                        c.Flash(mem);
                        if (c.Run(x, y) == 1)
                        {
                            beamed += 1;
                            xMin = x;
                            x += minLength;
                            beamed += minLength;

                            while (true)
                            {
                                c.Flash(mem);
                                if (c.Run(++x, y) == 0)
                                {
                                    minLength = x - xMin - 2;
                                    x = int.MaxValue - 1;
                                    break;
                                }
                                beamed += 1;
                            }
                        }
                    }
                }
            }

            Part1 = beamed.ToString();
        }
    }
}