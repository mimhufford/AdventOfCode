day23 :: (input: string) -> string, string
{
    elves := parse_map(input);

    curr : Table(s64, u8); // pos => count
    next : Table(s64, u8); // pos => count

    for elves
    {
        <<find_or_add(*curr, it.pos.hash) += 1;
    }

    for round: 1..10
    {
        table_reset(*next);

        for * e: elves
        {
            e.next = calculate_next_move(e, curr, round);
            <<find_or_add(*next, e.next.hash) += 1;
        }

        // the curr and next cells could be cached on the elf between passes to avoid double table lookup

        for * e: elves
        {
            if <<table_find_pointer(*next, e.next.hash) > 1 continue;
            <<table_find_pointer(*curr, e.pos.hash) -= 1;
            e.pos = e.next;
            <<find_or_add(*curr, e.pos.hash) += 1;
        }
    }

    x1, x2, y1, y2 := S32_MAX, S32_MIN, S32_MAX, S32_MIN;

    for curr
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

    area  := (x2-x1) * (y2-y1);
    empty := area - elves.count;

    return tprint("%", empty), tprint("%", "");
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
    pos  : V2;
    next : V2;
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

    wants_to_move := false;

    for dir: neighbours
    {
        cell := table_find_pointer(*map, (e.pos + dir).hash);
        if cell && <<cell
        {
            wants_to_move = true;
            break;
        }
    }

    if !wants_to_move return e.pos;

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