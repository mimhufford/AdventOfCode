using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace AoC
{
    public class IntCodeComputer
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

        public bool Run(params long[] inputs)
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

        public void OutputAssembly()
        {
            var i = 0;

            string Param(int p)
            {
                var mode = (int)(mem[i] / System.Math.Pow(10, p + 1) % 10);
                var val = mem[i + p];
                if (mode == 0) return $"[{val}] ";
                if (mode == 1) return $"{val} ";
                if (mode == 2) return $"({val}) ";
                Debug.Assert(false);
                return "ERROR";
            }

            void Print(string op, int numParams = 0)
            {
                string output = i.ToString("D4") + " " + op + " ";
                for (int p = 1; p <= numParams; p++) output += Param(p);
                Console.WriteLine(output);
                i += numParams + 1;
            }

            while (i < mem.Length)
            {
                var op = mem[i] % 100;

                if      (op == 1)    Print("ADD", 3);
                else if (op == 2)    Print("MUL", 3);
                else if (op == 3)    Print("INP", 1);
                else if (op == 4)    Print("OUT", 1);
                else if (op == 5)    Print("JNZ", 2);
                else if (op == 6)    Print("JEZ", 2);
                else if (op == 7)    Print("CLT", 3);
                else if (op == 8)    Print("CEQ", 3);
                else if (op == 9)    Print("SRB", 1);
                else if (op == 99)   Print("HLT");
                else if (op == 0)    i += 1;
                else                 Debug.Assert(false);
            }
        }
    }
}