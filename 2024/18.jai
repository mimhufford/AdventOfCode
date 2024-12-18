day18 :: (input: string) -> string, string
{
    for 1..1024
    {
        x := read_s64(*input); advance(*input);
        y := read_s64(*input);
        map[y][x] = true;
    }

    part1 := find_shortest_path();
    part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 71;
map : [SIZE][SIZE]bool;

find_shortest_path :: () -> s64
{
    seen : [SIZE][SIZE]bool;
    queue : [..] struct { x: s64; y: s64; steps: s64; };
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
            if map[ny][nx] continue;
            array_add(*queue, .{ nx, ny, steps + 1 });
        }
    }

    return 0;
}