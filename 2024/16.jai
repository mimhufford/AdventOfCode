day16 :: (input: string) -> string, string
{
    for y: 0..SIZE-1
    {
        for x: 0..SIZE-1
        {
            map[y][x] = ifx input[0] == #char "#" then WALL else S64_MAX;
            advance(*input);
        }   
        advance(*input);
    }

    walk(1, SIZE-2, 0, SIZE-2, 1);

    part1, part2 := map[1][SIZE-2], 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

WALL :: -1;
dirs :: []s64.[.[1,0],.[0,1],.[-1,0],.[0,-1]];
SIZE :: 141;
map : [SIZE][SIZE]s64;

walk :: (sx: s64, sy: s64, sd: s64, tx: s64, ty: s64)
{
    State :: struct { x, y, d, score : s64; }
    queue : [..]State;

    array_add(*queue, .{ sx, sy, sd, 0 });
    i := 0;

    while i < queue.count
    {
        defer i += 1;
        using queue[i];

        if map[y][x] < score continue;
        map[y][x] = score;

        for dir, dir_index: dirs
        {
            if map[y+dir[1]][x+dir[0]] == WALL continue;
            cost := 1 + ifx dir_index != d then 1000;
            array_add(*queue, .{ x+dir[0], y+dir[1], dir_index, score + cost });
        }
    }
}