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
        
        score := 0;

        for 0..24
        {
            number := read_u8(*input);
            if array_find(winners, number)
            {
                if score score *= 2;
                else     score  = 1;
            }
        }

        part1 += score;
    }
    
    return tprint("%", part1), tprint("%", part2);
}