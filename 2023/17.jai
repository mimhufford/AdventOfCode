day17 :: (input: string) -> string, string
{
    part1 := find_shortest_path(input, 1,  3);
    part2 := find_shortest_path(input, 4, 10);
    return tprint("%", part1), tprint("%", part2);
}

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
        if s.cost >= result continue;
        min_possible := s.cost + map[0].count-1-s.x + map.count-1-s.y;
        if min_possible >= result continue;

        if s.cost >= result continue;
        if s.cost >= seen[s.y*map[0].count+s.x][s.d] continue;
        seen[s.y*map[0].count+s.x][s.d] = s.cost;

        if s.x == map[0].count-1 && s.y == map.count-1
        {
            result = s.cost;
            continue;
        }
        
        if s.d == .L
        {
            cost_to_move := 0;
            for 1..max_steps
            {
                if s.x - it < 0 break;
                cost_to_move += map[s.y][s.x - it] - #char "0";
                if it < min_steps continue;
                array_add(*queue, .{cast(u8)(cast(s64)s.x - it), s.y, .U, s.cost + cost_to_move});
                array_add(*queue, .{cast(u8)(cast(s64)s.x - it), s.y, .D, s.cost + cost_to_move});
            }
        }
        else if s.d == .U
        {
            cost_to_move := 0;
            for 1..max_steps
            {
                if s.y - it < 0 break;
                cost_to_move += map[s.y - it][s.x] - #char "0";
                if it < min_steps continue;
                array_add(*queue, .{s.x, cast(u8)(cast(s64)s.y - it), .L, s.cost + cost_to_move});
                array_add(*queue, .{s.x, cast(u8)(cast(s64)s.y - it), .R, s.cost + cost_to_move});
            }
        }
        else if s.d == .R
        {
            cost_to_move := 0;
            for 1..max_steps
            {
                if s.x + it >= map[0].count break;
                cost_to_move += map[s.y][s.x + it] - #char "0";
                if it < min_steps continue;
                array_add(*queue, .{cast(u8)(cast(s64)s.x + it), s.y, .U, s.cost + cost_to_move});
                array_add(*queue, .{cast(u8)(cast(s64)s.x + it), s.y, .D, s.cost + cost_to_move});
            }
        }
        else if s.d == .D
        {
            cost_to_move := 0;
            for 1..max_steps
            {
                if s.y + it >= map.count break;
                cost_to_move += map[s.y + it][s.x] - #char "0";
                if it < min_steps continue;
                array_add(*queue, .{s.x, cast(u8)(cast(s64)s.y + it), .L, s.cost + cost_to_move});
                array_add(*queue, .{s.x, cast(u8)(cast(s64)s.y + it), .R, s.cost + cost_to_move});
            }
        }
    }

    return result;
}

#scope_file

State :: struct
{
    x, y : u8;
    d : Direction;
    cost : s64;
}

Direction :: enum u8 { L; R; U; D; }