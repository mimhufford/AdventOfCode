day12 :: (input: string) -> string, string
{
    map, sx, sy, ex, ey, width, height := generate_map(input);
    
    trail_lengths : [..]u16;

    array_add(*trail_lengths, find_shortest_path(sx, sy));
    
    return tprint("%", trail_lengths[0]), tprint("%", "");
}

#scope_file

Move :: struct
{
    x, y : s8;
    move : u16;
}

find_shortest_path :: (sx: s8, sy: s8) -> u16 #expand
{
    best : [..][..]u16;
    for 1..`height
    {
        row := array_add(*best);
        for 1..`width array_add(row, U16_MAX);
    }

    queue : [..]Move;
    array_add(*queue, .{sx, sy, 0});
    
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