day17 :: (input: string) -> string, string
{
    part1 := find_shortest_path(input, 1,  3);
    part2 := find_shortest_path(input, 4, 10);
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

find_shortest_path :: (input: string, min_steps: s64, max_steps: s64) -> s64
{
    map := split(trim(input), "\n");
    seen : [..][4]s64;
    for 1..map.count*map[0].count array_add(*seen, .[S64_MAX, S64_MAX, S64_MAX, S64_MAX]);

    result := S64_MAX;

    queue : [..]State;
    array_add(*queue, .{0, 0, .R, 0});
    array_add(*queue, .{0, 0, .D, 0});

    while queue.count
    {
        s := pop(*queue);
        if s.cost >= seen[s.y*map[0].count+s.x][s.d] continue;
        if s.cost + map[0].count-1-s.x + map.count-1-s.y >= result continue;
        seen[s.y*map[0].count+s.x][s.d] = s.cost;

        if s.x == map[0].count-1 && s.y == map.count-1
        {
            result = s.cost;
            continue;
        }

        dx, dy := dir_to_dx_dy(s.d);
        turns  := dir_to_turns(s.d);
        for 1..max_steps
        {
            x := cast(u8)(cast(s64)s.x + it*dx);
            y := cast(u8)(cast(s64)s.y + it*dy);
            if x < 0 break;
            if y < 0 break;
            if x >= map[0].count break;
            if y >= map.count break;
            s.cost += map[y][x] - #char "0";
            if s.cost >= result break;
            if it < min_steps continue;
            array_add(*queue, .{x, y, turns[0], s.cost});
            array_add(*queue, .{x, y, turns[1], s.cost});
        }
    }

    return result;
}

State :: struct
{
    x, y : u8;
    d : Direction;
    cost : s64;
}

dir_to_dx_dy :: (d: Direction) -> s8, s8
{
    if d == .L return -1,  0;
    if d == .R return  1,  0;
    if d == .U return  0, -1;
               return  0,  1;
}

dir_to_turns :: (d: Direction) -> [2]Direction
{
    if d == .L return .[.U, .D];
    if d == .R return .[.U, .D];
    if d == .U return .[.L, .R];
               return .[.L, .R];
}

Direction :: enum u8 { L; R; U; D; }