day4 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        part1 += check(input);
        advance(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check :: (s: string) -> s64
{
    return 0;
}