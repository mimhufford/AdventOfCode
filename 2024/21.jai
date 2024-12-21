day21 :: (input: string) -> string, string
{
    init_keys();

    while input
    {
        pos : u8 = #char "A";
        code := read_word(*input);
        presses := 0;
        for next: code
        {
            presses += move(pos, next);
            pos = next;
        }
        print("% %\n", code, presses);
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

key_pos : [128]Vector2;
key_dir : [128]Vector2;

move :: (start: u8, end: u8) -> s64
{
    return 1;
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