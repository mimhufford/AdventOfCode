day17 :: (input: string) -> string, string
{
    advance(*input, 12); a := read_s64(*input);
    advance(*input, 12); b := read_s64(*input);
    advance(*input, 12); c := read_s64(*input);
    advance(*input, 9);
    
    while input
    {
        n := read_number(s64, *input, skip_trailing_whitespace=false);
        advance(*input);
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}