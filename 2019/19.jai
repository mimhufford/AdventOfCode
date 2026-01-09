day19 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(array_copy(ram));

    inside :: (x: s64, y: s64) -> bool #expand {
        for ram c.ram[it_index] = it;
        reset(c);
        run(c, y, x);
        return pop(*c.out) == 1;
    }

    width_at_y_49, first_x_at_y_49 := 0;
    for y: 0..49 {
        first_x_at_y_49 = S64_MAX;
        width_at_y_49 = 0;
        for x: 0..49 {
            if !inside(x, y) continue;
            first_x_at_y_49 = min(first_x_at_y_49, x);
            part1, width_at_y_49 += 1;
        } 
    }

    first_y := 49 * 100 / width_at_y_49;
    x := first_y * first_x_at_y_49 / 49;
    for y: first_y..S64_MAX {
        while !inside(x, y) x += 1;
        if !inside(x + 99, y - 99) continue;
        part2 = (x * 10000) + y - 99;
        break;
    }

    return tprint("%", part1), tprint("%", part2);
}