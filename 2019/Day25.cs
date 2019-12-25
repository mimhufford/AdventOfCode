using System;
using System.Linq;
using System.Collections.Generic;

namespace AoC
{
    public class Day25 : Day
    {
        public Day25() : base(25) { }

        protected override void Solve()
        {
            var c = new IntCodeComputer();
            c.Flash(LongCSV.ToArray());
            c.Run();

            var good = new HashSet<string> { "candy cane", "boulder", "food ration", "asterisk", "mutex", "mug", "prime number", "loom" };
            var bad = new HashSet<string> { "photons", "infinite loop", "giant electromagnet", "escape pod", "molten lava" };

            var inputs = new Queue<string>(new List<string>
            {
                "south", "take boulder", "west", "take asterisk", "east", "east", "take food ration", "west", "north",
                "east", "take candy cane", "north", "east", "north", "take mug", "south", "west", "north", "take mutex", "north", "take prime number", "south", "south", "south",
                "east", "north", "take loom", "south", "east", "south", "east", "east",
                "drop candy cane", "drop loom", "drop food ration", "drop boulder", "north"
                // @TODO: don't bother picking these 4 up
            });

            /*
              p-#
              |
            #-m m
              | |
              #-# l  
              |   |  
            O-c---#-#   D
            |       |   |
          a-b-f   #-#-#-#

            */

            do
            {
                var input = inputs.Dequeue();
                c.Run(input.Append('\n').Select(c => (long)c).ToArray());
                if (inputs.Count == 0)
                {
                    Part1 = string.Join("", c.outputs.Select(i => (char)i));
                    Part1 = Part1.Substring(Part1.IndexOf("typing") + 7).Split(' ')[0];
                    Part2 = ":)";
                    return;
                }
                c.outputs.Clear();
            } while (true);
        }
    }
}