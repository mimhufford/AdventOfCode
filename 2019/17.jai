day17 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(ram);
    run(c);

    map : [29][65]u8;
    x, y := 1;

    for c.out {
        if it.(u8) == {
            case "\n"; x = 1; y += 1;
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

    px, py := 0;
    dx, dy := 0;

    for y: 0..map.count-1 {
        for x: 0..map[0].count-1 {
            if map[y][x] == {
                case "^"; px, py = x, y; dx, dy =  0, -1; break y;
                case "v"; px, py = x, y; dx, dy =  0, +1; break y;
                case "<"; px, py = x, y; dx, dy = -1,  0; break y;
                case ">"; px, py = x, y; dx, dy = +1,  0; break y;
            }
        }
    }

    path : [..]u8;

    while true {
        if map[py+dy][px+dx] != "#" {
            try :: (tdx: s64, tdy: s64, turn: u8) #expand {
                if map[py+tdy][px+tdx] == "#" {
                    array_add(*path, turn, ",");
                    dx, dy = tdx, tdy;
                    continue;
                }
            }
            try(+dy, -dx, "L");
            try(-dy, +dx, "R");
            break;
        }
        
        run : u8 = 0;
        while map[py+dy][px+dx] == "#" run, px, py += 1, dx, dy;
        if run > 9 array_add(*path, run / 10 + "0", ",");
        array_add(*path, run % 10 + "0", ",");
    }

    path.count -= 1;

    return tprint("%", part1), tprint("%", part2);
}