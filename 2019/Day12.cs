using System;
using System.Linq;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AoC
{
    public class Day12 : Day
    {
        public Day12() : base(12) { }

        class Moon
        {
            public int x, y, z, dx, dy, dz, ix, iy, iz;

            public Moon(int xx, int yy, int zz) { x = ix = xx; y = iy = yy; z = iz = zz; }

            public bool xHit => x == ix && dx == 0;
            public bool yHit => y == iy && dy == 0;
            public bool zHit => z == iz && dz == 0;

            public int Potential => Math.Abs(x) + Math.Abs(y) + Math.Abs(z);
            public int Kinetic => Math.Abs(dx) + Math.Abs(dy) + Math.Abs(dz);
        }

        protected override void Solve()
        {
            var moons = Lines.Select(l =>
            {
                var m = Regex.Matches(l, @"-?\d+");
                return new Moon(int.Parse(m[0].Value), int.Parse(m[1].Value), int.Parse(m[2].Value));
            }).ToArray();

            int xPeriod = 0, yPeriod = 0, zPeriod = 0;

            void Simulate(int i)
            {
                for (var ai = 0; ai < moons.Length; ai++)
                {
                    Moon a = moons[ai];
                    for (var bi = ai + 1; bi < moons.Length; bi++)
                    {
                        Moon b = moons[bi];
                        a.dx += a.x > b.x ? -1 : a.x < b.x ? 1 : 0;
                        a.dy += a.y > b.y ? -1 : a.y < b.y ? 1 : 0;
                        a.dz += a.z > b.z ? -1 : a.z < b.z ? 1 : 0;
                        b.dx += b.x > a.x ? -1 : b.x < a.x ? 1 : 0;
                        b.dy += b.y > a.y ? -1 : b.y < a.y ? 1 : 0;
                        b.dz += b.z > a.z ? -1 : b.z < a.z ? 1 : 0;
                    }

                    a.x += a.dx;
                    a.y += a.dy;
                    a.z += a.dz;
                }

                var m0 = moons[0]; var m1 = moons[1]; var m2 = moons[2]; var m3 = moons[3];
                if (xPeriod == 0 && m0.xHit && m1.xHit && m2.xHit && m3.xHit) xPeriod = i;
                if (yPeriod == 0 && m0.yHit && m1.yHit && m2.yHit && m3.yHit) yPeriod = i;
                if (zPeriod == 0 && m0.zHit && m1.zHit && m2.zHit && m3.zHit) zPeriod = i;
            }

            for (int i = 1; true; i++)
            {
                Simulate(i);

                if (i == 1000) Part1 = moons.Sum(m => m.Potential * m.Kinetic).ToString();

                if (i >= 1000 && xPeriod != 0 && yPeriod != 0 && zPeriod != 0)
                {
                    long gcd(long a, long b) => b != 0 ? gcd(b, a % b) : a;
                    long lcm(long a, long b) => a * b / gcd(a, b);

                    Part2 = lcm(lcm(xPeriod, yPeriod), zPeriod).ToString();
                    break;
                }
            }
        }
    }
}