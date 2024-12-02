day2 :: (input: string) -> string, string
{
    part1 := 0;

    while input
    {
        asc, desc, gaps_ok := true;
        last := read_number(s64, *input, skip_trailing_whitespace = false);

        while input && input[0] != #char "\n"
        {
            skip_whitespace(*input);
            next := read_number(s64, *input, skip_trailing_whitespace = false);

            if next >= last              desc = false;
            if next <= last               asc = false;
            if abs(next - last) > 3   gaps_ok = false;

            last = next;
        }

        part1 += ifx (asc || desc) && gaps_ok then 1 else 0;

        skip_whitespace(*input);
    }

    return tprint("%", part1), tprint("%", 0);
}