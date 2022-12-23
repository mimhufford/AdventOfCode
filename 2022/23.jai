day23 :: (input: string) -> string, string
{
    elves := parse_map(input);

    curr : Table(s64, u8); // pos => count
    next : Table(s64, u8); // pos => count

    for elves
    {
        <<find_or_add(*curr, it.pos.hash) += 1;
    }

    empty_10 := 0;
    complete := 0;

    for round: 1..S64_MAX
    {
        table_reset(*next);

        all_happy := true;

        for * e: elves
        {
            e.next = calculate_next_move(e, curr, round);
            <<find_or_add(*next, e.next.hash) += 1;
            if !e.happy  all_happy = false;
        }

        if all_happy
        {
            complete = round;
            break;
        }

        for * e: elves
        {
            if <<table_find_pointer(*next, e.next.hash) > 1 continue;
            <<table_find_pointer(*curr, e.pos.hash) -= 1;
            e.pos = e.next;
            <<find_or_add(*curr, e.pos.hash) += 1;
        }

        if round == 10 empty_10 = calculate_empty_cells(curr, elves);
    }

    return tprint("%", empty_10), tprint("%", complete);
}

#scope_file

V2 :: struct
{
    x, y : s32;
    #place x;
    hash : s64;
}

operator + :: (a: V2, b: V2) -> V2 { r := a; r.x += b.x; r.y += b.y; return r; }

Elf :: struct
{
    pos   : V2;
    next  : V2;
    happy : bool;
}

moves :: ([]V2).[
    .[ .{ 1,  0}, .{ 1, -1}, .{ 1,  1} ], // E
    .[ .{ 0, -1}, .{ 1, -1}, .{-1, -1} ], // N
    .[ .{ 0,  1}, .{ 1,  1}, .{-1,  1} ], // S
    .[ .{-1,  0}, .{-1, -1}, .{-1,  1} ], // W
];

neighbours :: V2.[
    .{-1, -1}, .{ 0, -1}, .{ 1, -1},
    .{-1,  0},            .{ 1,  0},
    .{-1,  1}, .{ 0,  1}, .{ 1,  1},
];

calculate_next_move :: (e: *Elf, map: Table(s64, u8), round: s64) -> V2
{
    // this does some repeat table lookups which could be avoided if needed

    e.happy = true;

    for dir: neighbours
    {
        cell := table_find_pointer(*map, (e.pos + dir).hash);
        if cell && <<cell
        {
            e.happy = false;
            break;
        }
    }

    if e.happy return e.pos;

    for i: 0..3
    {
        move := moves[(round + i) % 4];

        for dir: move
        {
            cell := table_find_pointer(*map, (e.pos + dir).hash);
            if cell && <<cell
            {
                continue i;
            }
        }

        return e.pos + move[0];
    }

    return e.pos;
}

calculate_empty_cells :: (map: Table(s64, u8), elves: []Elf) -> s64
{
    x1, x2, y1, y2 := S32_MAX, S32_MIN, S32_MAX, S32_MIN;

    for map
    {
        if it == 0 continue;
        assert(it == 1);
        p: V2;
        p.hash = it_index;
        x1 = min(x1, p.x);
        x2 = max(x2, p.x);
        y1 = min(y1, p.y);
        y2 = max(y2, p.y);
    }

    area  := (x2-x1+1) * (y2-y1+1);
    return area - elves.count;
}

parse_map :: (input: string) -> []Elf
{
    elves : [..]Elf;

    x, y : s32;

    while input
    {
        if input[0] == #char "#"
        {
            elf := array_add(*elves);
            elf.pos.x = x;
            elf.pos.y = y;
            x += 1;
        }
        else if input[0] == #char "."
        {
            x += 1;
        }
        else if input[0] == #char "\n"
        {
            x = 0;
            y += 1;
        }

        advance(*input);
    }

    return elves;
}