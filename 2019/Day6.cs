using System;
using System.Collections.Generic;
using System.Linq;

namespace AoC
{
    public class Day6 : Day
    {
        public Day6() : base(6) { }

        class Node
        {
            public Node parent;
        }

        protected override void Solve()
        {
            var nodes = new Dictionary<string, Node>();

            // pass 1: add nodes and link up parents
            int orbits = 0;
            foreach (var node in Lines)
            {
                var parts = node.Split(')');
                var parent = parts[0];
                var child = parts[1];
                if (!nodes.ContainsKey(parent)) nodes.Add(parent, new Node());
                if (!nodes.ContainsKey(child)) nodes.Add(child, new Node());
                nodes[child].parent = nodes[parent];
            }

            // pass 2: calculate total orbits
            foreach (var id in nodes.Keys)
            {
                var node = nodes[id];
                while (node.parent != null)
                {
                    orbits += 1;
                    node = node.parent;
                }
            }

            Part1 = orbits.ToString();
        }
    }
}