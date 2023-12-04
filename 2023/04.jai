day4 :: (input: string) -> string, string
{
    part1, part2 := 0, 0;
    copies : [256]s64;

    while input.count
    {
        advance_then_skip_whitespace(*input, 5); // skip "Card "
        id := read_u8(*input);
        advance_then_skip_whitespace(*input, 2); // skip ": "

        winners : [10]u8;

        for 0..9 winners[it] = read_u8(*input);

        advance_then_skip_whitespace(*input, 1); // skip "|"
        
        matches := 0;

        for 0..24 if array_find(winners, read_u8(*input)) matches += 1;

        part2 += copies[id] + 1;
        if matches part1 += 1 << (matches - 1);
        for id+1..id+matches copies[it] += copies[id] + 1;
    }
    
    return tprint("%", part1), tprint("%", part2);
}