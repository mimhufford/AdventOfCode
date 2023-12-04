day4 :: (input: string) -> string, string
{
    part1, part2 := 0, 0;

    while input.count
    {
        advance(*input, 9); // skip "Card X: "
        skip_whitespace(*input);

        winners : [10]u8;

        for 0..9 winners[it] = read_u8(*input);

        advance(*input); // skip "|"
        skip_whitespace(*input);
        
        matches := 0;

        for 0..24
        {
            number := read_u8(*input);
            if array_find(winners, number) matches += 1;
        }

        if matches part1 += 1 << (matches-1);
    }
    
    return tprint("%", part1), tprint("%", part2);
}