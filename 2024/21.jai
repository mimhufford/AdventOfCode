day21 :: (input: string) -> string, string
{
    init_keys();

    part1, part2 := 0;
    
    while input
    {
        code := read_word(*input);
        number := read_s64(*tprint(code));
        part1 += number * enter(code, 3,  num_pad);
        part2 += number * enter(code, 26, num_pad);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

num_pad, dir_pad : [128]Vector2;
cache : Table(string, Table(s64, s64));

enter :: (keys: string, depth: s64, pos: []Vector2) -> s64
{
    cache_1 := table_find_pointer(*cache, cast(string)keys);
    if cache_1
    {
        cache_2 := table_find_pointer(cache_1, depth);
        if cache_2 return cache_2.*;
    }

    if !depth return keys.count;

    result := 0;
    curr_key : u8 = #char "A";

    for next_key: keys
    {
        queue : [..] struct { pos: Vector2; steps: s64; keys: [..]u8; };
        first := array_add(*queue);
        first.pos = pos[curr_key];

        ways : [..]s64;

        for queue
        {
            if it.pos == pos[next_key]
            {
                array_add(*it.keys, #char "A");
                array_add(*ways, it_index);
                continue;
            }

            curr_item := it;

            for d: Vector2.[.{1,0},.{0,1},.{-1,0},.{0,-1}]
            {
                next_pos := curr_item.pos + d;
                
                // avoid the void
                if next_pos.x == 0 && next_pos.y == 3 continue;
                
                // don't move away from the goal
                if abs(pos[next_key].x - next_pos.x) > abs(pos[next_key].x - curr_item.pos.x) continue;
                if abs(pos[next_key].y - next_pos.y) > abs(pos[next_key].y - curr_item.pos.y) continue;

                // all good fam
                next_item := array_add(*queue);
                next_item.pos = next_pos;
                next_item.steps = curr_item.steps + 1;
                array_add(*next_item.keys, ..curr_item.keys);
                array_add(*next_item.keys, dir_key(d));
            }
        }

        best := S64_MAX;
        for ways best = min(best, enter(xx queue[it].keys, depth - 1, dir_pad));
        result += best;

        curr_key = next_key;
    }

    find_or_add(find_or_add(*cache, cast(string)keys), depth).* = result;
    return result;
}

dir_key :: (d: Vector2) -> u8
{
    if d.x == -1 && d.y ==  0 return #char "<";
    if d.x ==  1 && d.y ==  0 return #char ">";
    if d.x ==  0 && d.y ==  1 return #char "v";
    if d.x ==  0 && d.y == -1 return #char "^";
    return 0;
}

init_keys :: ()
{
    num_pad[#char "7"] = .{0, 0};
    num_pad[#char "8"] = .{1, 0};  // +---+---+---+
    num_pad[#char "9"] = .{2, 0};  // | 7 | 8 | 9 |
    num_pad[#char "4"] = .{0, 1};  // +---+---+---+
    num_pad[#char "5"] = .{1, 1};  // | 4 | 5 | 6 |
    num_pad[#char "6"] = .{2, 1};  // +---+---+---+
    num_pad[#char "1"] = .{0, 2};  // | 1 | 2 | 3 |
    num_pad[#char "2"] = .{1, 2};  // +---+---+---+
    num_pad[#char "3"] = .{2, 2};  //     | 0 | A |
    num_pad[#char "0"] = .{1, 3};  //     +---+---+
    num_pad[#char "A"] = .{2, 3};

    dir_pad[#char "^"] = .{1, 3};  //     +---+---+
    dir_pad[#char "<"] = .{0, 4};  //     | ^ | A |
    dir_pad[#char "v"] = .{1, 4};  // +---+---+---+
    dir_pad[#char ">"] = .{2, 4};  // | < | v | > |
    dir_pad[#char "A"] = .{2, 3};  // +---+---+---+
}