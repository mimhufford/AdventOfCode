day3 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        if input[0] == #char "m"
        {
            part1 += parse_mul(input);
        }

        advance(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

parse_mul :: (s: string) -> s64
{
    if s.count < 8 return 0;
    if s[0] != #char "m" return 0; advance(*s);
    if s[0] != #char "u" return 0; advance(*s);
    if s[0] != #char "l" return 0; advance(*s);
    if s[0] != #char "(" return 0; advance(*s);
    if s[0] <  #char "0" return 0;
    if s[0] >  #char "9" return 0;
    num1 := read_number(s64, *s, skip_trailing_whitespace = false);
    if s[0] != #char "," return 0; advance(*s);
    if s[0] <  #char "0" return 0;
    if s[0] >  #char "9" return 0;
    num2 := read_number(s64, *s, skip_trailing_whitespace = false);
    if s[0] != #char ")" return 0;
    return num1 * num2;
}