day4 :: (input: string) -> string, string
{
    part1, part2 : s64;
    to_remove : [..]s64;

    SIZE :: 135;

    for iteration: 0..S64_MAX {
        array_reset_keeping_memory(*to_remove);

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

                array_add(*to_remove, y * (SIZE+1) + x);
                part1 += ifx iteration == 0 then 1;
                part2 += 1;
            }
        }

        if to_remove.count == 0 break;
        for to_remove input[it] = ".";
    }

    return tprint("%", part1), tprint("%", part2);
}