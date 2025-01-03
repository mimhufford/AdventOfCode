day20 :: (input: string) -> string, string
{
    sx, sy : s64;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        if input[y * (SIZE+1) + x] == {
            case #char "#"; map[y][x] = -1;
            case #char "S"; sx, sy = x, y; #through;
            case; map[y][x] = S64_MAX;
        }
    }

    bfs(sx, sy);
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

        count :: () #expand
        {
            moves := abs(`dx) + `dy;
            if moves > 20 continue;
            nx, ny := `x + `dx, `y + `dy;
            if nx < 0 || nx >= SIZE continue;
            if ny < 0 || ny >= SIZE continue;
            if map[ny][nx] == -1 continue;
            if map[y][x] - map[ny][nx] - moves >= 100 lil_cheats, big_cheats += ifx moves == 2 then 1, 1;
            if map[ny][nx] - map[y][x] - moves >= 100 lil_cheats, big_cheats += ifx moves == 2 then 1, 1;
        }

        for dy: 0..00 for dx:     2..20     count();
        for dy: 1..20 for dx: dy-20..20-dy  count();
    }

    return lil_cheats, big_cheats;
}

bfs :: (sx: s64, sy: s64)
{
    seen : [SIZE][SIZE]bool;
    queue : [..] struct { x: s64; y: s64; steps: s64; };
    array_add(*queue, .{ sx, sy, 0 });

    for queue
    {
        using curr := it;

        seen[y][x] = true;
        map[y][x] = steps;

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