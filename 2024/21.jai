day21 :: (input: string) -> string, string
{
    while input
    {
        code := read_word(*input);
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}