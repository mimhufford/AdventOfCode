day21 :: (input: string) -> string, string
{
    init_keys();

    part1, part2 := 0;
    
    while input
    {
        code := read_word(*input);
        number := read_s64(*tprint(code));
        print("%\n====\n", code);
        presses := enter_num_pad(code);
        part1 += number * presses;
        print("====\n%: %*% = %\n", code, number, presses, number * presses);
        break;
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

        #if 1
        {
            print("% to %\n", str(curr_key), str(next_key));
            for ways
            {
                print(" %: ", it_index+1);
                for queue[it].keys print(str(it));
                print("\n");
            }
        }
        
        best := S64_MAX;
        for ways best = min(best, enter_dir_pad(queue[it].keys));
        result += best;
    }

    return result;
}

enter_dir_pad :: (keys: []u8, start : u8 = #char "A", depth := 2) -> s64
{
    if !depth return 0;
    if !keys return 0;

    curr_key_pos := dir_pad[start];
    next_key_pos := dir_pad[keys[0]];
    
    diff := next_key_pos - curr_key_pos;
    steps := cast(s64)(abs(diff.x) + abs(diff.y));

    queue : [..] struct { pos: Vector2; steps: s64; keys: [..]u8; };
    first := array_add(*queue);
    first.pos = curr_key_pos;

    ways : [..]s64;

    for queue
    {
        if it.pos == next_key_pos { array_add(*ways, it_index); continue; }
        if it.steps == steps continue;

        curr_item := it;

        for d: Vector2.[.{1,0},.{0,1},.{-1,0},.{0,-1}]
        {
            next_pos := curr_item.pos + d;
            
            // avoid the void
            if next_pos.x == 0 && next_pos.y == 0 continue;
            
            // don't move away from the goal
            steps_left := steps - curr_item.steps;
            if manhattan_distance(next_pos, next_key_pos) > steps_left continue;

            // all good fam
            next_item := array_add(*queue);
            next_item.pos = next_pos;
            next_item.steps = curr_item.steps + 1;
            array_add(*next_item.keys, ..curr_item.keys);
            array_add(*next_item.keys, dir_key(d));
        }
    }

    #if 1
    {
        print("% to %\n", str(start), str(keys[0]));
        for ways
        {
            print(" %: ", it_index+1);
            for queue[it].keys print(str(it));
            print("\n");
        }
    }

    result := S64_MAX;
    for ways result = min(result, enter_dir_pad(.{queue[it].keys.count - 1, queue[it].keys.data + 1}, queue[it].keys[0], depth - 1));
    return result;
}

// Temporary while debugging
str :: (c: u8) -> string
{
    if c == #char "A" return "A";
    if c == #char "0" return "0";
    if c == #char "1" return "1";
    if c == #char "2" return "2";
    if c == #char "3" return "3";
    if c == #char "4" return "4";
    if c == #char "5" return "5";
    if c == #char "6" return "6";
    if c == #char "7" return "7";
    if c == #char "8" return "8";
    if c == #char "9" return "9";
    if c == #char "<" return "<";
    if c == #char "v" return "v";
    if c == #char ">" return ">";
    if c == #char "^" return "^";
    assert(false);
    return "";
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