day21 :: (input: string) -> string, string
{
    init_keys();

    while input
    {
        code := read_word(*input);
        presses := enter_numpad(code);
        print("% %\n", code, presses);
        break;
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

key_pos : [128]Vector2;
key_dir : [128]Vector2;

enter_numpad :: (code: string, start := #char "A") -> s64
{
    if !code return 0;

    curr_key_pos := key_pos[start];
    next_key_pos := key_pos[code[0]];
    
    diff := next_key_pos - curr_key_pos;
    steps := cast(s64)(abs(diff.x) + abs(diff.y));

    queue : [..] struct { pos: Vector2; steps: s64; };
    array_add(*queue, .{ curr_key_pos, 0 });

    ways := 0;

    for queue
    {
        if it.pos == next_key_pos { ways += 1; continue; }
        if it.steps == steps continue;

        curr_item := it;

        for d: Vector2.[.{1,0},.{0,1},.{-1,0},.{0,-1}]
        {
            next_pos := curr_item.pos + d;
            
            // avoid the void
            if next_pos.x == 0 && next_pos.y == 3 continue;
            
            // don't move away from the goal
            steps_left := steps - curr_item.steps;
            if manhattan_distance(next_pos, next_key_pos) > steps_left continue;

            // all good fam
            array_add(*queue, .{ next_pos, curr_item.steps + 1 });
        }
    }

    print("% > %: % steps, % ways, % queued\n", start - #char "0", code[0] - #char "0", steps, ways, queue.count);

    enter_numpad(advance(code), code[0]);

    return 1;
}

enter_dirpad :: () -> s64
{
    return 0;
}

manhattan_distance :: (a: Vector2, b: Vector2) -> s64
{
    return cast(s64)(abs(b.x - a.x) + abs(b.y - a.y));
}

init_keys :: ()
{
    // keypad
    key_pos[#char "7"] = .{0, 0};
    key_pos[#char "8"] = .{1, 0};  // +---+---+---+
    key_pos[#char "9"] = .{2, 0};  // | 7 | 8 | 9 |
    key_pos[#char "4"] = .{0, 1};  // +---+---+---+
    key_pos[#char "5"] = .{1, 1};  // | 4 | 5 | 6 |   favour going right and up
    key_pos[#char "6"] = .{2, 1};  // +---+---+---+   to avoid landing in the void
    key_pos[#char "1"] = .{0, 2};  // | 1 | 2 | 3 |
    key_pos[#char "2"] = .{1, 2};  // +---+---+---+
    key_pos[#char "3"] = .{2, 2};  //     | 0 | A |
    key_pos[#char "0"] = .{1, 3};  //     +---+---+
    key_pos[#char "A"] = .{2, 3};

    // dirpad
    key_pos[#char "^"] = .{1, 0};  //     +---+---+
    key_pos[#char "<"] = .{0, 1};  //     | ^ | A |
    key_pos[#char "v"] = .{1, 1};  // +---+---+---+   favour going right and down
    key_pos[#char ">"] = .{2, 1};  // | < | v | > |   to avoid landing in the void
    key_pos[#char "a"] = .{2, 0};  // +---+---+---+

    key_dir[#char "^"] = .{ 0,-1};
    key_dir[#char "<"] = .{-1, 0};
    key_dir[#char "v"] = .{ 0, 1};
    key_dir[#char ">"] = .{ 1, 0};
}