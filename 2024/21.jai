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

    curr := key_pos[start];
    next := key_pos[code[0]];
    diff := next - curr;

    print("from % to %: %\n", start - #char "0", code[0] - #char "0", diff);

    enter_numpad(advance(code), code[0]);

    return 1;
}

enter_dirpad :: () -> s64
{
    return 0;
}

init_keys :: ()
{
    // keypad (shifted 1 to the right so [0,0] can be a void check)
    key_pos[#char "7"] = .{1, 0};
    key_pos[#char "8"] = .{2, 0};  // +---+---+---+
    key_pos[#char "9"] = .{3, 0};  // | 7 | 8 | 9 |
    key_pos[#char "4"] = .{1, 1};  // +---+---+---+
    key_pos[#char "5"] = .{2, 1};  // | 4 | 5 | 6 |   favour going right and up
    key_pos[#char "6"] = .{3, 1};  // +---+---+---+   to avoid landing in the void
    key_pos[#char "1"] = .{1, 2};  // | 1 | 2 | 3 |
    key_pos[#char "2"] = .{2, 2};  // +---+---+---+
    key_pos[#char "3"] = .{3, 2};  //     | 0 | A |
    key_pos[#char "0"] = .{2, 3};  //     +---+---+
    key_pos[#char "A"] = .{3, 3};

    // dirpad (no need to shift, [0,0] is already a void)
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