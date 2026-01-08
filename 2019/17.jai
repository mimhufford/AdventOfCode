day17 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);
    run(c);

    map : [27][63]u8;
    x, y := 0;

    for c.out {
        if it.(u8) == {
            case "\n"; x = 0; y += 1;
            case; map[y][x] = it.(u8); x += 1;
        }
    }

    for y: 1..map.count-2 {
        for x: 1..map[0].count-2 {
            if map[y  ][x  ] != "#" continue;
            if map[y+1][x  ] != "#" continue;
            if map[y-1][x  ] != "#" continue;
            if map[y  ][x+1] != "#" continue;
            if map[y  ][x-1] != "#" continue;
            part1 += x * y;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}