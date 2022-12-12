day12 :: (input: string) -> string, string
{
    map, best, sx, sy, ex, ey, width, height := generate_map(input);

    queue : [..]Move;
    array_add(*queue, .{sx, sy, 0});
    
    while queue
    {
        curr := pop(*queue);
        best[curr.y][curr.x] = curr.move;

        for []s8.[.[1,0],.[-1,0],.[0,1],.[0,-1]]
        {
            next : Move = .{curr.x + it[0], curr.y + it[1], curr.move + 1};
            if next.x < 0 || next.x >= width     continue;
            if next.y < 0 || next.y >= height    continue;
            if best[next.y][next.x] <= next.move continue;
            if map[next.y][next.x] > map[curr.y][curr.x] + 1 continue;
            array_add(*queue, next);
        }
    }
    
    return tprint("%", best[ey][ex]), tprint("%", "");
}

#scope_file

Move :: struct
{
    x, y : s8;
    move : u16;
}

generate_map :: (input: string) -> [..][..]u8, [..][..]u16, s8, s8, s8, s8, s8, s8
{
    map : [..][..]u8;
    best : [..][..]u16;
    sx, sy, ex, ey : s8;
    
    x, y : s8;

    while input
    {
        x = 0;
        row := array_add(*map);
        best_row := array_add(*best);
        while true
        {
            if      input[0] == #char "\n" { advance(*input); break; }
            else if input[0] == #char "S"  { sx = x; sy = y; array_add(row,  0); }
            else if input[0] == #char "E"  { ex = x; ey = y; array_add(row, 25); }
            else array_add(row, input[0] - #char "a");
            advance(*input);
            array_add(best_row, U16_MAX);
            x += 1;
        }
        y += 1;
    }

    return map, best, sx, sy, ex, ey, xx map[0].count, xx map.count;
}