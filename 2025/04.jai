day4 :: (input: string) -> string, string
{
    part1, part2 : s64;

    SIZE :: 135;
    queue : [..]s64;

    for char, index: input {
        if char != "@" then input[index] = 255;
    }

    for char, index: input {
        if char == 255 continue;
        input[index] = 0;
        for diff: s64.[-SIZE-2, -SIZE-1, -SIZE, -1, +1, +SIZE, +SIZE+1, +SIZE+2] {
            n_index := index + diff;
            if n_index < 0 continue;
            if n_index >= input.count continue;
            if input[n_index] == 255 continue;
            input[index] += 1;
        }
        if input[index] > 3 continue;
        array_add(*queue, index);
        part1 += 1;
    }

    while queue {
        index := pop(*queue);
        if input[index] > 3 continue;

        input[index] = 255;
        part2 += 1;

        for diff: s64.[-SIZE-2, -SIZE-1, -SIZE, -1, +1, +SIZE, +SIZE+1, +SIZE+2] {
            n_index := index + diff;
            if n_index < 0 continue;
            if n_index >= input.count continue;
            if input[n_index] == 255 continue;
            input[n_index] -= 1;
            if input[n_index] <= 3 then array_add(*queue, n_index);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}