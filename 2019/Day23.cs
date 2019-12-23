using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day23 : Day
    {
        public Day23() : base(23) { }

        protected override void Solve()
        {
            var mem = LongCSV.ToArray();
            var prv = 1L;
            var nat = (0L, 0L);
            var net = new IntCodeComputer[50];
            var sig = new Queue<long>[50];

            for (int i = 0; i < 50; i++)
            {
                var c = net[i] = new IntCodeComputer();
                c.Flash(mem);
                c.Run(i);
                sig[i] = new Queue<long>();
            }

            while (Part2 == null)
            {
                var idle = true;

                for (int i = 0; i < 50; i++)
                {
                    var c = net[i];
                    if (c.outputs.Count > 0)
                    {
                        idle = false;
                        var si = c.outputs.Dequeue();
                        if (si != 255)
                        {
                            sig[si].Enqueue(c.outputs.Dequeue());
                            sig[si].Enqueue(c.outputs.Dequeue());
                        }
                        else
                        {
                            var x = c.outputs.Dequeue();
                            var y = c.outputs.Dequeue();
                            nat = (x, y);
                            if (Part1 == null) Part1 = y.ToString();
                        }
                    }
                }

                if (idle)
                {
                    sig[0].Enqueue(nat.Item1);
                    sig[0].Enqueue(nat.Item2);
                    if (prv == nat.Item2) Part2 = prv.ToString();
                    else prv = nat.Item2;
                }

                for (int i = 0; i < 50; i++)
                {
                    var c = net[i];
                    var s = sig[i];
                    if (s.Count > 0) c.Run(s.ToArray());
                    else c.Run(-1);
                    s.Clear();
                }
            }
        }
    }
}