day7 :: (input: string) -> string, string
{
    part1, part2 : s64;

    beams : [150]s64;
    col, row := 0;

    for input {
        defer col += 1;
        if it == "\n"  { col = -1; row += 1; continue; }
        if it == "S"   { beams[col] = 1; continue; }
        if it != "^"   { continue; }
        if !beams[col] { continue; }
        beams[col-1] += beams[col];
        beams[col+1] += beams[col];
        beams[col] = 0;
        part1 += 1;
    }

    for beams part2 += it;

    return tprint("%", part1), tprint("%", part2);
}