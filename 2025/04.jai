day4 :: (input: string) -> string, string
{
    part1, part2 : s64;

    queue : [..]s64;
    array_reserve(*queue, 32_000);

    for char, index: input {
        if char != "@" continue;

        neighbours := get_neighbours(input, index);
        if neighbours.count > 3 continue;

        array_add(*queue, index);
        part1 += 1;
    }

    for index: queue {
        if input[index] != "@" continue;

        neighbours := get_neighbours(input, index);
        if neighbours.count > 3 continue;

        part2 += 1;
        input[index] = ".";
        array_add(*queue, ..neighbours);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

neighbours : [..]s64;

get_neighbours :: inline (input: string, index: s64) -> []s64 {
    array_reset_keeping_memory(*neighbours);

    SIZE :: 135;
    x := index % (SIZE + 1);
    y := index / (SIZE + 1);
    x_min := max(x - 1, 0);
    x_max := min(x + 1, SIZE-1);
    y_min := max(y - 1, 0);
    y_max := min(y + 1, SIZE-1);

    for nx: x_min..x_max {
        for ny: y_min..y_max {
            if nx == x && ny == y continue;
            if input[ny * (SIZE + 1) + nx] != "@" continue;
            array_add(*neighbours, ny * (SIZE + 1) + nx);
        }
    }

    return neighbours;
}