day17 :: (input: string) -> string, string
{
    return day17partoneslow(input, 1, 3), day17parttwoslow(input, 4, 10);
}

day17partoneslow :: (input: string, min_steps: s64, max_steps: s64) -> string
{
    map := split(trim(input), "\n");
    seen : [..][3][4]s64;
    for 1..map.count*map[0].count array_add(*seen, .[
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX]]);

    part1 := S64_MAX;

    queue : [..]State;
    array_add(*queue, .{0, 0, 0, .R, 0});
    array_add(*queue, .{0, 0, 0, .D, 0});

    while queue.count
    {
        s := pop(*queue);
        if s.cost >= part1 continue;
        if s.d_count == max_steps continue;
        min_possible := s.cost + map[0].count-1-s.x + map.count-1-s.y;
        if min_possible >= part1 continue;

        dx, dy := direction_to_dx_dy(s.d);
        if s.x == 0 && dx == -1 continue;
        if s.y == 0 && dy == -1 continue;
        if s.x == map[0].count-1 && dx == 1 continue;
        if s.y == map.count-1    && dy == 1 continue;

        s.x = xx (cast(s64)s.x + dx);
        s.y = xx (cast(s64)s.y + dy);
        s.cost += map[s.y][s.x] - #char "0";
        if s.cost >= part1 continue;
        if s.cost >= seen[s.y*map[0].count+s.x][s.d_count][s.d] continue;
        seen[s.y*map[0].count+s.x][s.d_count][s.d] = s.cost;

        if s.x == map[0].count-1 && s.y == map.count-1 && s.d_count >= min_steps-1
        {
            part1 = s.cost;
            continue;
        }
        
        if s.d == .L
        {
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .U, s.cost});
            array_add(*queue, .{s.x, s.y, s.d_count+1, .L, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .D, s.cost});
        }
        else if s.d == .U
        {
            array_add(*queue, .{s.x, s.y, s.d_count+1, .U, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .L, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .R, s.cost});
        }
        else if s.d == .R
        {
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .U, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .D, s.cost});
            array_add(*queue, .{s.x, s.y, s.d_count+1, .R, s.cost});
        }
        else if s.d == .D
        {
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .L, s.cost});
            array_add(*queue, .{s.x, s.y, s.d_count+1, .D, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .R, s.cost});
        }
    }

    return tprint("%", part1);
}

day17parttwoslow :: (input: string, min_steps: s64, max_steps: s64) -> string
{
    map := split(trim(input), "\n");
    seen : [..][10][4]s64;
    for 1..map.count*map[0].count array_add(*seen, .[
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX],
        .[S64_MAX,S64_MAX,S64_MAX,S64_MAX]]);

    part1 := S64_MAX;

    queue : [..]State;
    array_add(*queue, .{0, 0, 0, .R, 0});
    array_add(*queue, .{0, 0, 0, .D, 0});

    while queue.count
    {
        s := pop(*queue);
        if s.cost >= part1 continue;
        if s.d_count == max_steps continue;
        min_possible := s.cost + map[0].count-1-s.x + map.count-1-s.y;
        if min_possible >= part1 continue;

        dx, dy := direction_to_dx_dy(s.d);
        if s.x == 0 && dx == -1 continue;
        if s.y == 0 && dy == -1 continue;
        if s.x == map[0].count-1 && dx == 1 continue;
        if s.y == map.count-1    && dy == 1 continue;

        s.x = xx (cast(s64)s.x + dx);
        s.y = xx (cast(s64)s.y + dy);
        s.cost += map[s.y][s.x] - #char "0";
        if s.cost >= part1 continue;
        if s.cost >= seen[s.y*map[0].count+s.x][s.d_count][s.d] continue;
        seen[s.y*map[0].count+s.x][s.d_count][s.d] = s.cost;

        if s.x == map[0].count-1 && s.y == map.count-1 && s.d_count >= min_steps-1
        {
            part1 = s.cost;
            continue;
        }
        
        if s.d == .L
        {
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .U, s.cost});
            array_add(*queue, .{s.x, s.y, s.d_count+1, .L, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .D, s.cost});
        }
        else if s.d == .U
        {
            array_add(*queue, .{s.x, s.y, s.d_count+1, .U, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .L, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .R, s.cost});
        }
        else if s.d == .R
        {
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .U, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .D, s.cost});
            array_add(*queue, .{s.x, s.y, s.d_count+1, .R, s.cost});
        }
        else if s.d == .D
        {
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .L, s.cost});
            array_add(*queue, .{s.x, s.y, s.d_count+1, .D, s.cost});
            if s.d_count >= min_steps-1 array_add(*queue, .{s.x, s.y, 0, .R, s.cost});
        }
    }

    return tprint("%", part1);
}

#scope_file

State :: struct
{
    x, y : u8;
    d_count : u8;
    d : Direction;
    cost : s64;
}

direction_to_dx_dy :: (d: Direction) -> s8, s8
{
    if d == .L return -1,  0;
    if d == .R return  1,  0;
    if d == .U return  0, -1;
               return  0,  1;
}

Direction :: enum u8 { L; R; U; D; }