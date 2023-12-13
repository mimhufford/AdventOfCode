day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for split(trim(input), "\n\n")
    {
        map  := split(it, "\n");
        w, h := map[0].count, map.count;

        part1, part2 += mirror(map, w, h, 1);
        part1, part2 += mirror(map, h, w, 100);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

mirror :: (map: []string, dim1: s64, dim2: s64, mult: s64) -> s64, s64
{
    score1, score2 := 0;

    for i: 1..dim1-1
    {
        errors := 0;
        mirror := 0.5 * ((i-1) + i);

        for j: 0..dim2-1
        {
            for a: 0..i-1
            {
                b := cast(s64)(2*mirror - a);
                if b >= dim1 continue;
                if mult == 1 && map[j][a] != map[j][b] errors += 1;
                if mult != 1 && map[a][j] != map[b][j] errors += 1;
                if errors > 1 continue i;
            }
        }

        if errors == 0 score1 += mult * cast(s64)ceil(mirror);
        if errors == 1 score2 += mult * cast(s64)ceil(mirror);
    }

    return score1, score2;
}