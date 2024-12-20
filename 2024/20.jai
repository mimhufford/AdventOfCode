day20 :: (input: string) -> string, string
{
    sx, sy, ex, ey : s64;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        map[y][x] = S64_MAX;

        if input[y * (SIZE+1) + x] == {
            case #char "S"; sx, sy = x, y;
            case #char "E"; ex, ey = x, y;
            case #char "#"; map[y][x] = -1;
        }
    }

    bfs(sx, sy, ex, ey);
    part1, part2 := count_cheats();

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 141;
map : [SIZE][SIZE] s64;

count_cheats :: () -> s64, s64
{
    lil_cheats, big_cheats := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        if map[y][x] == -1 continue;

        for dy: -20..20 for dx: -20..20
        {
            moves := abs(dx) + abs(dy);
            if moves > 20 continue;
            nx, ny := x + dx, y + dy;
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            if map[ny][nx] == -1 continue;
            if map[y][x] - map[ny][nx] - abs(ny - y) - abs(nx - x) < 100 continue;
            lil_cheats, big_cheats += ifx moves == 2 then 1, 1;
        }
    }

    return lil_cheats, big_cheats;
}

bfs :: (sx: s64, sy: s64, ex: s64, ey: s64)
{
    seen : [SIZE][SIZE]bool;
    queue : [..] struct { x: s64; y: s64; steps: s64; };
    array_add(*queue, .{ sx, sy, 0 });

    for queue
    {
        using curr := it;

        seen[y][x] = true;
        map[y][x] = steps;

        if x == ex && y == ey return;

        for d: []s32.[.[1,0],.[0,1],.[-1,0],.[0,-1]]
        {
            nx, ny := x + d[0], y + d[1];
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            if map[ny][nx] == -1 continue;
            if seen[ny][nx] continue;
            seen[ny][nx] = true;
            array_add(*queue, .{ nx, ny, steps + 1 });
        }
    }
}