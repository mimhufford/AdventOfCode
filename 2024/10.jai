day10 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        i := y*(SIZE+1) + x;
        if input[i] != #char "0" continue;
        part1, part2 += walk(input, x, y);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 50;

walk :: (map: string, x: s64, y: s64) -> s64, s64
{
    walk :: (map: string, x: s64, y: s64, unique: *[..]s64, combos: *s64)
    {
        for []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]]
        {
            nx, ny := x+it[0], y+it[1];
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            ci :=  y*(SIZE+1) +  x;
            ni := ny*(SIZE+1) + nx;
            if map[ci] + 1 != map[ni] continue;
            if map[ni] == #char "9"
            {
                array_add_if_unique(unique, ni);
                combos.* += 1;
            }
            else
            {
                walk(map, nx, ny, unique, combos);
            }
        }
    }

    unique : [..]s64;
    combos := 0;
    walk(map, x, y, *unique, *combos);
    return unique.count, combos;
}