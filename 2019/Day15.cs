using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day15 : Day
    {
        public Day15() : base(15) { }

        class Computer
        {
            public int[] mem;
            public int ip = 0;

            public void Flash(int[] memory)
            {
                mem = new int[1106];
                for (int i = 0; i < memory.Length; i++) mem[i] = memory[i];
                ip = 0;
            }

            (int, int, int) Params()
            {
                var mode0 = mem[ip] / 100 % 10;
                var mode1 = mem[ip] / 1000 % 10;
                var mode2 = mem[ip] / 10000 % 10;
                var a = mode0 == 0 ? mem[mem[ip + 1]] : mem[ip + 1];
                var b = mode1 == 0 ? mem[mem[ip + 2]] : mem[ip + 2];
                var c = mem[ip + 3];
                return (a, b, c);
            }

            public int Run(int input)
            {
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
                        a = mem[ip + 1];
                        mem[a] = input;
                        ip += 2;
                    }
                    else if (op == 4)
                    {
                        ip += 2;
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
                }

                return 0;
            }
        }

        class Bot
        {
            public Computer c = new Computer();
            public (int x, int y) pos;
            public int dist;
            public int cameFrom; // don't go back this way

            public Bot(int[] memory, int dist, int cameFrom, (int x, int y) pos)
            {
                c.Flash(memory);
                this.dist = dist;
                this.cameFrom = cameFrom;
                this.pos = pos;
            }

            public void Move(int dir)
            {
                c.Run(dir);
            }

            public int Probe(int dir)
            {
                var tile = c.Run(dir);
                if (tile != 0)
                {
                    if (dir == 1) c.Run(2);
                    else if (dir == 2) c.Run(1);
                    else if (dir == 3) c.Run(4);
                    else if (dir == 4) c.Run(3);
                }
                return tile;
            }
        }

        protected override void Solve()
        {
            var NORTH = 1; var SOUTH = 2; var WEST = 3; var EAST = 4;
            var FLOOR = 1; var OXYGEN = 2;

            var map = new HashSet<(int x, int y)>() { { (0, 0) } };
            var oxygen = (0, 0);

            var bots = new Queue<Bot>();
            bots.Enqueue(new Bot(IntCSV.ToArray(), 0, 0, (0, 0)));

            while (bots.Count > 0)
            {
                var b = bots.Dequeue();

                void Go(int dir, int reverseDir, int dx, int dy)
                {
                    if (b.cameFrom != dir)
                    {
                        var tile = b.Probe(dir);
                        var pos = (b.pos.x + dx, b.pos.y + dy);
                        if (tile != 0)
                        {
                            map.Add(pos);
                            if (tile == OXYGEN)
                            {
                                oxygen = pos;
                                Part1 = (b.dist + 1).ToString();
                            }
                            else if (tile == FLOOR)
                            {
                                var nb = new Bot(b.c.mem, b.dist + 1, reverseDir, pos);
                                nb.Move(dir);
                                bots.Enqueue(nb);
                            }
                        }
                    }
                }

                Go(NORTH, SOUTH, 0, -1);
                Go(SOUTH, NORTH, 0, 1);
                Go(EAST, WEST, 1, 0);
                Go(WEST, EAST, -1, 0);
            }
        }
    }
}