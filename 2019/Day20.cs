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
            // Phase 2: Simplify the graph
            //

            var nodes = new Dictionary<(int x, int y), Dictionary<(int x, int y), int>>();

            {
                var seen = new HashSet<((int x, int y), (int x, int y))>();
                var points = new HashSet<(int x, int y)>(portals.Keys);
                points.Add((ax, ay)); points.Add((zx, zy));
                var q = new Queue<(int x1, int y1, int x2, int y2, int dist)>();
                points.ToList().ForEach(k => q.Enqueue((k.x, k.y, k.x, k.y, 0)));

                while (q.Count > 0)
                {
                    (var x1, var y1, var x2, var y2, var dist) = q.Dequeue();
                    var start = (x1, y1);
                    var current = (x2, y2);

                    if (seen.Contains((start, current))) continue;

                    if (dist > 0 && points.Contains(current))
                    {
                        if (!nodes.ContainsKey(start))
                            nodes.Add(start, new Dictionary<(int x, int y), int>());
                        nodes[start][current] = dist;
                    }

                    seen.Add((start, current));

                    void CheckNeighbour((int x, int y) n)
                    {
                        if (!map.Contains(n)) return;
                        q.Enqueue((x1, y1, n.x, n.y, dist + 1));
                    }

                    CheckNeighbour((x2 + 1, y2));
                    CheckNeighbour((x2 - 1, y2));
                    CheckNeighbour((x2, y2 + 1));
                    CheckNeighbour((x2, y2 - 1));
                }
            }

            // 
            // Phase 3: BFS from a to z with recursive depth
            //

            {
                var seen = new HashSet<(int x, int y, int depth)>();
                var q = new Queue<(int x, int y, int depth, int steps)>();
                q.Enqueue((ax, ay, 0, 0));

                while (q.Count > 0)
                {
                    (var x, var y, var depth, var steps) = q.Dequeue();

                    if (seen.Contains((x, y, depth))) continue;

                    seen.Add((x, y, depth));

                    if (x == zx && y == zy)
                    {
                        if (Part1 == null) Part1 = steps.ToString();
                        if (depth == 0000) Part2 = steps.ToString();
                        if (Part1 != null && Part2 != null) break;
                    }

                    if (nodes.ContainsKey((x, y)))
                    {
                        foreach (var n in nodes[(x, y)].Keys)
                        {
                            q.Enqueue((n.x, n.y, depth, steps + nodes[(x, y)][n]));
                        }
                    }

                    if (portals.ContainsKey((x, y)))
                    {
                        var dd = (x == lf || x == rg || y == tp || y == bt) ? -1 : 1;
                        if (dd == -1 && depth == 0) continue;
                        q.Enqueue((portals[(x, y)].x, portals[(x, y)].y, depth + dd, steps + 1));
                    }
                }
            }
        }
    }
}