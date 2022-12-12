day12 :: (input: string) -> string, string
{
    map, sx, sy, ex, ey, width, height := generate_map(input);
    
    part1 := find_shortest_path_up(sx, sy);
    part2 := find_shortest_path_down(ex, ey);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Move :: struct
{
    x, y : s8;
    move : u16;
}

find_shortest_path_down :: (x: s8, y: s8) -> u16 #expand
{
    best : [..][..]u16;
    for 1..`height
    {
        row := array_add(*best);
        for 1..`width array_add(row, U16_MAX);
    }

    queue : [..]Move;
    array_add(*queue, .{x, y, 0});
    
    while queue
    {
        curr := pop(*queue);
        best[curr.y][curr.x] = curr.move;

        for []s8.[.[1,0],.[-1,0],.[0,1],.[0,-1]]
        {
            next : Move = .{curr.x + it[0], curr.y + it[1], curr.move + 1};
            if next.x < 0 || next.x >= `width     continue;
            if next.y < 0 || next.y >= `height    continue;
            if best[next.y][next.x] <= next.move  continue;
            if `map[curr.y][curr.x] > `map[next.y][next.x] + 1 continue;
            array_add(*queue, next);
        }
    }

    best_0 := U16_MAX;
    for y: 0..`height-1 for x: 0..`width-1 if `map[y][x] == 0 best_0 = min(best_0, best[y][x]);
    return best_0;
}

find_shortest_path_up :: (x: s8, y: s8) -> u16 #expand
{
    best : [..][..]u16;
    for 1..`height
    {
        row := array_add(*best);
        for 1..`width array_add(row, U16_MAX);
    }

    queue : [..]Move;
    array_add(*queue, .{x, y, 0});
    
    while queue
    {
        curr := pop(*queue);
        best[curr.y][curr.x] = curr.move;

        for []s8.[.[1,0],.[-1,0],.[0,1],.[0,-1]]
        {
            next : Move = .{curr.x + it[0], curr.y + it[1], curr.move + 1};
            if next.x < 0 || next.x >= `width     continue;
            if next.y < 0 || next.y >= `height    continue;
            if best[next.y][next.x] <= next.move  continue;
            if `map[next.y][next.x] > `map[curr.y][curr.x] + 1 continue;
            array_add(*queue, next);
        }
    }

    return best[`ey][`ex];
}

generate_map :: (input: string) -> [..][..]u8, s8, s8, s8, s8, s8, s8
{
    map : [..][..]u8;
    sx, sy, ex, ey : s8;
    
    x, y : s8;

    while input
    {
        x = 0;
        row := array_add(*map);
        while true
        {
            if      input[0] == #char "\n" { advance(*input); break; }
            else if input[0] == #char "S"  { sx = x; sy = y; array_add(row,  0); }
            else if input[0] == #char "E"  { ex = x; ey = y; array_add(row, 25); }
            else array_add(row, input[0] - #char "a");
            advance(*input);

            x += 1;
        }
        y += 1;
    }

    return map, sx, sy, ex, ey, xx map[0].count, xx map.count;
}