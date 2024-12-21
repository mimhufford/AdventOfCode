day21 :: (input: string) -> string, string
{
    init_keys();

    part1, part2 := 0;
    
    while input
    {
        code := read_word(*input);
        number := read_s64(*tprint(code));
        presses := enter_num_pad(code);
        part1 += number * presses;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

num_pad, dir_pad : [128]Vector2;

enter_num_pad :: (keys: string) -> s64
{
    result := 0;
    curr_key : u8 = #char "A";

    for next_key: keys
    {
        defer curr_key = next_key;

        diff := num_pad[next_key] - num_pad[curr_key];
        max_steps := cast(s64)(abs(diff.x) + abs(diff.y));

        queue : [..] struct { pos: Vector2; steps: s64; keys: [..]u8; };
        first := array_add(*queue);
        first.pos = num_pad[curr_key];

        ways : [..]s64;

        for queue
        {
            if it.pos == num_pad[next_key]
            {
                array_add(*it.keys, #char "A");
                array_add(*ways, it_index);
                continue;
            }

            if it.steps == max_steps continue;

            curr_item := it;

            for d: Vector2.[.{1,0},.{0,1},.{-1,0},.{0,-1}]
            {
                next_pos := curr_item.pos + d;
                
                // avoid the void
                if next_pos.x == 0 && next_pos.y == 3 continue;
                
                // don't move away from the goal
                steps_left := max_steps - curr_item.steps;
                if manhattan_distance(next_pos, num_pad[next_key]) > steps_left continue;

                // all good fam
                next_item := array_add(*queue);
                next_item.pos = next_pos;
                next_item.steps = curr_item.steps + 1;
                array_add(*next_item.keys, ..curr_item.keys);
                array_add(*next_item.keys, dir_key(d));
            }
        }

        best := S64_MAX;
        for ways best = min(best, enter_dir_pad(queue[it].keys));
        result += best;
    }

    return result;
}

enter_dir_pad :: (keys: []u8, depth := 2) -> s64
{
    if !depth return keys.count;

    result := 0;
    curr_key : u8 = #char "A";

    for next_key: keys
    {
        defer curr_key = next_key;

        diff := dir_pad[next_key] - dir_pad[curr_key];
        max_steps := cast(s64)(abs(diff.x) + abs(diff.y));

        queue : [..] struct { pos: Vector2; steps: s64; keys: [..]u8; };
        first := array_add(*queue);
        first.pos = dir_pad[curr_key];

        ways : [..]s64;

        for queue
        {
            if it.pos == dir_pad[next_key]
            {
                array_add(*it.keys, #char "A");
                array_add(*ways, it_index);
                continue;
            }

            if it.steps == max_steps continue;

            curr_item := it;

            for d: Vector2.[.{1,0},.{0,1},.{-1,0},.{0,-1}]
            {
                next_pos := curr_item.pos + d;
                
                // avoid the void
                if next_pos.x == 0 && next_pos.y == 0 continue;
                
                // don't move away from the goal
                steps_left := max_steps - curr_item.steps;
                if manhattan_distance(next_pos, dir_pad[next_key]) > steps_left continue;

                // all good fam
                next_item := array_add(*queue);
                next_item.pos = next_pos;
                next_item.steps = curr_item.steps + 1;
                array_add(*next_item.keys, ..curr_item.keys);
                array_add(*next_item.keys, dir_key(d));
            }
        }

        best := S64_MAX;
        for ways best = min(best, enter_dir_pad(queue[it].keys, depth - 1));
        result += best;
    }

    return result;
}

dir_key :: (d: Vector2) -> u8
{
    if d.x == -1 && d.y ==  0 return #char "<";
    if d.x ==  1 && d.y ==  0 return #char ">";
    if d.x ==  0 && d.y ==  1 return #char "v";
    if d.x ==  0 && d.y == -1 return #char "^";
    assert(false);
    return 0;
}

manhattan_distance :: (a: Vector2, b: Vector2) -> s64
{
    return cast(s64)(abs(b.x - a.x) + abs(b.y - a.y));
}

init_keys :: ()
{
    num_pad[#char "7"] = .{0, 0};
    num_pad[#char "8"] = .{1, 0};  // +---+---+---+
    num_pad[#char "9"] = .{2, 0};  // | 7 | 8 | 9 |
    num_pad[#char "4"] = .{0, 1};  // +---+---+---+
    num_pad[#char "5"] = .{1, 1};  // | 4 | 5 | 6 |   favour going right and up
    num_pad[#char "6"] = .{2, 1};  // +---+---+---+   to avoid landing in the void
    num_pad[#char "1"] = .{0, 2};  // | 1 | 2 | 3 |
    num_pad[#char "2"] = .{1, 2};  // +---+---+---+
    num_pad[#char "3"] = .{2, 2};  //     | 0 | A |
    num_pad[#char "0"] = .{1, 3};  //     +---+---+
    num_pad[#char "A"] = .{2, 3};

    dir_pad[#char "^"] = .{1, 0};  //     +---+---+
    dir_pad[#char "<"] = .{0, 1};  //     | ^ | A |
    dir_pad[#char "v"] = .{1, 1};  // +---+---+---+   favour going right and down
    dir_pad[#char ">"] = .{2, 1};  // | < | v | > |   to avoid landing in the void
    dir_pad[#char "A"] = .{2, 0};  // +---+---+---+
}