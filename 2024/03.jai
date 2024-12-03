day3 :: (input: string) -> string, string
{
    active := true;
    part1, part2 := 0;

    while input
    {
        if input[0] == #char "m" && starts_with(input, "mul(")
        {
            amount := parse_mul(advance(input, 4));
            part1, part2 += amount, ifx active then amount;
        }
        else if input[0] == #char "d"
        {
            if starts_with(input, "do()")    active = true;
            if starts_with(input, "don't()") active = false;
        }

        advance(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

parse_mul :: (s: string) -> s64
{
    if !is_digit(s[0]) return 0;
    num1 := read_number(s64, *s, skip_trailing_whitespace = false);
    if s[0] != #char "," return 0;
    advance(*s);
    if !is_digit(s[0]) return 0;
    num2 := read_number(s64, *s, skip_trailing_whitespace = false);
    if s[0] != #char ")" return 0;
    return num1 * num2;
}