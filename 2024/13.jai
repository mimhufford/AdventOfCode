day13 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        advance(*input, 12); ax := read_s64(*input);
        advance(*input,  4); ay := read_s64(*input);
        advance(*input, 12); bx := read_s64(*input);
        advance(*input,  4); by := read_s64(*input);
        advance(*input,  9); tx := read_s64(*input);
        advance(*input,  4); ty := read_s64(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}