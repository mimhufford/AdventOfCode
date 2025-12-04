day4 :: (input: string) -> string, string
{
    part1 := inline scan(input, true);
    part2 := inline scan(input, false);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

scan :: (input: string, once: bool) -> s64 {
    SIZE :: 135;
    total := 0;
    while true {
        removed := 0;
        for y: 0..SIZE-1 {
            for x: 0..SIZE-1 {
                if input[y*(SIZE+1) + x] != "@" continue;

                neighbours := 0;

                for dx: -1..1 {
                    for dy: -1..1 {
                        if dx == 0 && dy == 0 continue;
                        nx, ny := x + dx, y + dy;
                        if nx < 0 continue;
                        if ny < 0 continue;
                        if nx >= SIZE continue;
                        if ny >= SIZE continue;
                        if input[ny*(SIZE+1) + nx] != "@" continue;
                        neighbours += 1;
                        if neighbours >= 4 continue x;
                    }
                }

                if !once then input[y*(SIZE+1) + x] = ".";
                total += 1;
                removed += 1;
            }
        }
        if once || removed == 0 break;
    }
    return total;
}