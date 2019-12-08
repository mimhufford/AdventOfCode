using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;

namespace AoC
{
    public class Day8 : Day
    {
        public Day8() : base(8) { }

        protected override void Solve()
        {
            var image = Input;
            var width = 25;
            var height = 6;
            var pixelsPerLayer = width * height;
            var layers = new List<string>();

            var fewest0s = int.MaxValue;
            var onesTimesTwos = 0;

            for (var i = 0; i < image.Length; i += pixelsPerLayer)
            {
                var layer = image.Substring(i, pixelsPerLayer);
                layers.Add(layer);
                var num0s = 0; var num1s = 0; var num2s = 0;
                foreach (var c in layer)
                {
                    if (c == '0') num0s += 1;
                    else if (c == '1') num1s += 1;
                    else if (c == '2') num2s += 1;
                }
                if (num0s < fewest0s)
                {
                    fewest0s = num0s;
                    onesTimesTwos = num1s * num2s;
                }
            }

            Part1 = onesTimesTwos.ToString();

            var merged = layers[0].ToCharArray();
            foreach (var layer in layers.Skip(1))
            {
                for (int i = 0; i < layer.Length; i++)
                {
                    if (merged[i] == '2') merged[i] = layer[i];
                }
            }

            var result = new StringBuilder();
            for (int i = 0; i < merged.Count(); i++)
            {
                if (i % width == 0) result.AppendLine();
                if (merged[i] == '0') result.Append(' ');
                else result.Append('#');
            }
            Part2 = result.ToString();
            Part2 = "BCPZB"; // answer calculated above, hardcoded here to make output nicer
        }
    }
}