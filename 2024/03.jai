day3 :: (input: string) -> string, string
{
    active := true;
    part1, part2 := 0;

    while input
    {
        if input[0] == #char "m"
        {
            amount := parse_mul(input);
            part1 += amount;
            if active part2 += amount;
        }
        else if input[0] == #char "d"
        {
            if parse_do(input)   active = true;
            if parse_dont(input) active = false;
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

parse_do :: (s: string) -> bool
{
    if s.count < 4 return false;
    if s[0] != #char "d" return false; advance(*s);
    if s[0] != #char "o" return false; advance(*s);
    if s[0] != #char "(" return false; advance(*s);
    if s[0] != #char ")" return false;
    print("do");
    return true;
}

parse_dont :: (s: string) -> bool
{
    if s.count < 7 return false;
    if s[0] != #char "d" return false; advance(*s);
    if s[0] != #char "o" return false; advance(*s);
    if s[0] != #char "n" return false; advance(*s);
    if s[0] != #char "'" return false; advance(*s);
    if s[0] != #char "t" return false; advance(*s);
    if s[0] != #char "(" return false; advance(*s);
    if s[0] != #char ")" return false;
    print("dont");
    return true;
}