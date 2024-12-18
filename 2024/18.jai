day18 :: (input: string) -> string, string
{
    for map for * it it.* = S64_MAX;

    for 0..S64_MAX
    {
        x := read_s64(*input); advance(*input);
        y := read_s64(*input);
        map[y][x] = it;
        if !input break;
    }

    part1 := find_shortest_path(1024);
    part2 := find_first_impossible();

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 71;
map : [SIZE][SIZE]s64;
seen : [SIZE][SIZE]bool;
queue : [..] struct { x: s64; y: s64; steps: s64; };

find_first_impossible :: () -> string
{
    l, r := 1024, 3450;
    while l <= r
    {
        m := (l+r) / 2;
        if find_shortest_path(m) l = m + 1;
        else                     r = m - 1;
    }
    for y: 0..SIZE-1 for x: 0..SIZE-1 if map[y][x] == l-1 return tprint("%,%", x, y);
    return "";
}

find_shortest_path :: (time: s64) -> s64
{
    memset(seen.data, 0, SIZE*SIZE);
    array_reset_keeping_memory(*queue);
    array_add(*queue, .{ 0, 0, 0 });

    for queue
    {
        using curr := it;

        if x == SIZE-1 && y == SIZE-1 return steps;

        if seen[y][x] continue;
        seen[y][x] = true;

        for d: []s32.[.[1,0],.[0,1],.[-1,0],.[0,-1]]
        {
            nx, ny := x + d[0], y + d[1];
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            if seen[ny][nx] continue;
            if map[ny][nx] < time continue;
            array_add(*queue, .{ nx, ny, steps + 1 });
        }
    }

    return 0;
}