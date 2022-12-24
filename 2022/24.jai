day24 :: (input: string) -> string, string
{
    map, sx, sy, tx, ty := generate_map_for_each_cycle(input);

    goal_1 := walk(map, sx, sy, tx, ty, 0);
    snacks := walk(map, tx, ty, sx, sy, goal_1);
    goal_2 := walk(map, sx, sy, tx, ty, snacks);

    return tprint("%", goal_1), tprint("%", goal_2);
}

#scope_file

State :: struct
{
    x, y   : u16;
    minute : u32;
    #place x;
    hash   : u64;
}

history : Table(u64, u8);

walk :: (map: [..][..][..]u8, x: u16, y: u16, tx: u16, ty: u16, minute: u32) -> u32
{
    table_reset(*history);

    w, h, c := map[0][0].count, map[0].count, map.count;

    queue : [..]State;
    start := array_add(*queue);
    start.x = x;
    start.y = y;
    start.minute = minute;

    for 0..S64_MAX
    {
        if it == queue.count break;

        s := queue[it];
        if s.x == tx && s.y == ty return s.minute;

        cycled_s := s;
        cycled_s.minute %= cast(u32)c;
        if table_find_pointer(*history, cycled_s.hash) continue;
        table_add(*history, cycled_s.hash, 0);

        s.minute += 1;

        if s.x < w-1 && map[s.minute % c][ s.y ][s.x+1] == 0 { n := s;  n.x += 1;  array_add(*queue, n); }
        if s.y < h-1 && map[s.minute % c][s.y+1][ s.x ] == 0 { n := s;  n.y += 1;  array_add(*queue, n); }
        if s.x > 0   && map[s.minute % c][ s.y ][s.x-1] == 0 { n := s;  n.x -= 1;  array_add(*queue, n); }
        if s.y > 0   && map[s.minute % c][s.y-1][ s.x ] == 0 { n := s;  n.y -= 1;  array_add(*queue, n); }
        if              map[s.minute % c][ s.y ][ s.x ] == 0 { n := s;             array_add(*queue, n); }
    }

    return 0;
}

generate_map_for_each_cycle :: (input: string) -> [..][..][..]u8, u16, u16, u16, u16
{
    map : [..][..][..]u8; // time, y, x
    _ := array_add(*map); // add entry for time = 0

    while input
    {
        row := array_add(*map[0]);

        while true
        {
            defer advance(*input);

            if input[0] == {
                case #char "."; array_add(row, 0);
                case #char "#"; array_add(row, X);
                case #char "<"; array_add(row, L);
                case #char ">"; array_add(row, R);
                case #char "^"; array_add(row, U);
                case #char "v"; array_add(row, D);
                case; break;
            }
        }
    }

    w, h := map[0][0].count, map[0].count;

    cycle := lcm(w-2, h-2);

    for 1..cycle-1
    {
        time := array_add(*map);

        // add everything as walkable to start with
        for prev_row: map[it-1] array_resize(array_add(time), prev_row.count);

        // now update with new positions
        for prev_row, y: map[it-1]
        {
            for prev_col, x: prev_row
            {
                if prev_col & X then (<<time)[ y ][ x ] |= X;
                if prev_col & L { if x > 1   then (<<time)[ y ][x-1] |= L; else (<<time)[ y ][w-2] |= L; }
                if prev_col & R { if x < w-2 then (<<time)[ y ][x+1] |= R; else (<<time)[ y ][ 1 ] |= R; }
                if prev_col & U { if y > 1   then (<<time)[y-1][ x ] |= U; else (<<time)[h-2][ x ] |= U; }
                if prev_col & D { if y < h-2 then (<<time)[y+1][ x ] |= D; else (<<time)[ 1 ][ x ] |= D; }
            }
        }
    }

    return map, 1, 0, cast(u16)(w-2), cast(u16)(h-1);
}

X :: 0b_1111_0000;
L :: 0b_0000_0001;
R :: 0b_0000_0010;
U :: 0b_0000_0100;
D :: 0b_0000_1000;

lcm :: (a: s64, b: s64) -> s64 { return a / gcd(a, b) * b; }
gcd :: (a: s64, b: s64) -> s64 { if b return gcd(b, a % b); return a; };