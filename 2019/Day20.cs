using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day20 : Day
    {
        public Day20() : base(20) { }

        protected override void Solve()
        {
            var portals = new Dictionary<(int x, int y), (int x, int y)>();
            var map = new HashSet<(int x, int y)>();
            var ax = 0; var ay = 0; var zx = 0; var zy = 0;
            var lf = 2; var rg = 0; var tp = 2; var bt = 0;

            //
            // Phase 1: Build map info
            //
            {
                var input = Lines.ToArray();
                var portalPos = new Dictionary<string, List<(int x, int y)>>();
                bt = input.Length - 3; rg = input[0].Length - 3;

                for (int y = 1; y < input.Length - 1; y++)
                {
                    for (int x = 1; x < input[y].Length - 1; x++)
                    {
                        var tile = input[y][x];

                        if (tile == ' ') continue;
                        if (tile == '#') continue;
                        if (tile == '.') { map.Add((x, y)); continue; }

                        void RecordPortal(string portal, int x, int y)
                        {
                            if (portal == "AA") { ax = x; ay = y; return; }
                            if (portal == "ZZ") { zx = x; zy = y; return; }

                            var pos = (x, y);

                            if (!portalPos.ContainsKey(portal))
                                portalPos.Add(portal, new List<(int x, int y)>(2));

                            var portalPositions = portalPos[portal];

                            portalPositions.Add(pos);

                            if (portalPositions.Count == 2)
                            {
                                portals.Add(portalPositions[0], portalPositions[1]);
                                portals.Add(portalPositions[1], portalPositions[0]);
                            }
                        }

                        if (input[y - 1][x] == '.')
                        {
                            RecordPortal($"{tile}{input[y + 1][x]}", x, y - 1);
                        }
                        else if (input[y][x - 1] == '.')
                        {
                            RecordPortal($"{tile}{input[y][x + 1]}", x - 1, y);
                        }
                        else if (input[y + 1][x] == '.')
                        {
                            RecordPortal($"{input[y - 1][x]}{tile}", x, y + 1);
                        }
                        else if (input[y][x + 1] == '.')
                        {
                            RecordPortal($"{input[y][x - 1]}{tile}", x + 1, y);
                        }
                    }
                }
            }

            // 
            // Phase 2: BFS from a to z with recursive depth
            //
            {
                var seen = new HashSet<(int x, int y, int depth)>();
                var q = new Queue<(int x, int y, int depth, int steps)>();
                q.Enqueue((ax, ay, 0, 0));

                while (q.Count > 0)
                {
                    (var x, var y, var depth, var steps) = q.Dequeue();

                    seen.Add((x, y, depth));

                    if (x == zx && y == zy)
                    {
                        if (Part1 == null) Part1 = steps.ToString();
                        if (depth == 0000) Part2 = steps.ToString();
                        if (Part1 != null && Part2 != null) break;
                    }

                    void CheckNeighbour((int x, int y) n)
                    {
                        if (seen.Contains((n.x, n.y, depth))) return;
                        if (portals.ContainsKey(n))
                        {
                            var dd = (n.x == lf || n.x == rg || n.y == tp || n.y == bt) ? -1 : 1;
                            if (dd == -1 && depth == 0) return;
                            q.Enqueue((portals[n].x, portals[n].y, depth + dd, steps + 2));
                        }
                        else if (map.Contains(n))
                            q.Enqueue((n.x, n.y, depth, steps + 1));
                    }

                    CheckNeighbour((x + 1, y));
                    CheckNeighbour((x - 1, y));
                    CheckNeighbour((x, y + 1));
                    CheckNeighbour((x, y - 1));
                }
            }
        }
    }
}