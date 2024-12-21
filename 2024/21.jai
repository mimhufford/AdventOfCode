day21 :: (input: string) -> string, string
{
    init_key_positions();

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

key_positions : [128]Vector2;

move :: (start: u8, end: u8) -> s64
{
    return 1;
}

init_key_positions :: ()
{
    // keypad
    key_positions[#char "7"] = .{0, 0};
    key_positions[#char "8"] = .{1, 0};  // +---+---+---+
    key_positions[#char "9"] = .{2, 0};  // | 7 | 8 | 9 |
    key_positions[#char "4"] = .{0, 1};  // +---+---+---+
    key_positions[#char "5"] = .{1, 1};  // | 4 | 5 | 6 |
    key_positions[#char "6"] = .{2, 1};  // +---+---+---+
    key_positions[#char "1"] = .{0, 2};  // | 1 | 2 | 3 |
    key_positions[#char "2"] = .{1, 2};  // +---+---+---+
    key_positions[#char "3"] = .{2, 2};  //     | 0 | A |
    key_positions[#char "0"] = .{1, 3};  //     +---+---+
    key_positions[#char "A"] = .{2, 3};

    // dirpad
    key_positions[#char "^"] = .{1, 0};  //     +---+---+
    key_positions[#char "<"] = .{0, 1};  //     | ^ | A |
    key_positions[#char "v"] = .{1, 1};  // +---+---+---+
    key_positions[#char ">"] = .{2, 1};  // | < | v | > |
    key_positions[#char "a"] = .{2, 0};  // +---+---+---+
}