day12 :: (input: string) -> string, string
{
    map, sx, sy, ex, ey, width, height := generate_map(input);
    
    part1 := find_shortest_path(sx, sy, true);
    part2 := find_shortest_path(ex, ey, false);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Move :: struct
{
    x, y : s8;
    move : u16;
}

find_shortest_path :: (x: s8, y: s8, up: bool) -> u16 #expand
{
    visited := NewArray(`width * `height, bool);
    queue : [..]Move;
    array_add(*queue, .{x, y, 0});
    index := 0;
    
    while index < queue.count
    {
        curr := queue[index];
        index += 1;

        for []s8.[.[1,0],.[-1,0],.[0,1],.[0,-1]]
        {
            next : Move = .{curr.x + it[0], curr.y + it[1], curr.move + 1};
            if next.x < 0 || next.x >= `width                         continue;
            if next.y < 0 || next.y >= `height                        continue;
            if visited[next.y*`width+next.x]                          continue;
            if  up && `map[next.y][next.x] > `map[curr.y][curr.x] + 1 continue;
            if !up && `map[curr.y][curr.x] > `map[next.y][next.x] + 1 continue;
            if  up && next.x == `ex && next.y == `ey                  return next.move;
            if !up && `map[next.y][next.x] == 0                       return next.move;
            visited[next.y*`width+next.x] = true;
            array_add(*queue, next);
        }
    }

    assert(false);
    return 0;
}

generate_map :: (input: string) -> [..][..]u8, s8, s8, s8, s8, s64, s64
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

    return map, sx, sy, ex, ey, map[0].count, map.count;
}