day17 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(array_copy(ram));
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
                    array_add(*path, turn);
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
        if run > 9 array_add(*path, run / 10 + "0");
        array_add(*path, run % 10 + "0");
    }

    // print("%\n", path.(string));

    // L8R12R12R10R10R12R10L8R12R12R10R10R12R10L10R10L6L10R10L6R10R12R10L8R12R12R10R10R12R10L10R10L6
    // A          R10R12R10A          R10R12R10L10R10L6L10R10L6R10R12R10A          R10R12R10L10R10L6
    // A          B        A          B        L10R10L6L10R10L6B        A          B        L10R10L6
    // A          B        A          B        C       C       B        A          B        C       

    best_length := 0;
    best_index  := 0;
    best_total  := 0;
    repeats : [..]s64;

    for length: 7..9 {
        for i: 0..path.count-length {
            array_reset_keeping_memory(*repeats);
            chunk := slice(path.(string), i, length);
            repeat := find_index_from_left(path.(string), chunk, i + length);
            while repeat != -1 {
                array_add(*repeats, repeat);
                repeat = find_index_from_left(path.(string), chunk, repeat + length);
            }
            if repeats.count {
                total := (repeats.count + 1) * length;
                if total <= best_total continue;
                best_length = length;
                best_index = i;
                best_total = total;
                // print("Found % repeats of '%' = %\n", repeats.count, chunk, total);
            }
        }
    }

    // TODO: calculate the input

    c = computer(ram);
    reset(c);
    c.ram[0] = 2;
    in : [..]s64;
    for < "A,B,A,B,C,C,B,A,B,C\nL,8,R,12,R,12,R,10\nR,10,R,12,R,10\nL,10,R,10,L,6\nn\n" {
        array_add(*in, it);
    }
    run(c, .. in);
    part2 = peek(c.out);

    return tprint("%", part1), tprint("%", part2);
}