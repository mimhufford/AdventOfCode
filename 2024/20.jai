day20 :: (input: string) -> string, string
{
    sx, sy, ex, ey : s64;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        if input[y * (SIZE+1) + x] == {
            case #char "S"; sx, sy = x, y;
            case #char "E"; ex, ey = x, y;
            case #char "#"; map[y][x].wall = true;
        }
    }

    bfs(sx, sy, ex, ey, start_to_end = true);
    bfs(ex, ey, sx, sy, start_to_end = false);

    baseline_cost := map[ey][ex].cost_s2e;

    part1 := count_cheats(baseline_cost, 100);
    part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 141;
map : [SIZE][SIZE] struct { wall: bool; cost_s2e := S64_MAX; cost_e2s := S64_MAX; };

count_cheats :: (baseline: s64, min_saving: s64) -> s64
{
    cheats := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-2
    {
        if map[y][x].cost_s2e == S64_MAX continue;

        for d: []s32.[.[2,0],.[0,2],.[-2,0],.[0,-2]]
        {
            nx, ny := x + d[0], y + d[1];
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            if map[ny][nx].cost_e2s == S64_MAX continue;
            cost := map[y][x].cost_s2e + map[ny][nx].cost_e2s + 2;
            cheats += ifx cost <= baseline - min_saving then 1;
        }
    }

    return cheats;
}

bfs :: (sx: s64, sy: s64, ex: s64, ey: s64, start_to_end: bool)
{
    seen : [SIZE][SIZE]bool;
    queue : [..] struct { x: s64; y: s64; steps: s64; };
    array_add(*queue, .{ sx, sy, 0 });

    for queue
    {
        using curr := it;

        if start_to_end map[y][x].cost_s2e = steps;
        else            map[y][x].cost_e2s = steps;

        if x == ex && y == ey return;

        for d: []s32.[.[1,0],.[0,1],.[-1,0],.[0,-1]]
        {
            nx, ny := x + d[0], y + d[1];
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            if map[ny][nx].wall continue;
            if seen[ny][nx] continue;
            seen[ny][nx] = true;
            array_add(*queue, .{ nx, ny, steps + 1 });
        }
    }
}