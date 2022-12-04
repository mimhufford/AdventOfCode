day4 :: (input: string) -> string, string
{
    contained := 0;
    overlap   := 0;

    while input.count
    {
        lo_1 := read_number(u32, *input, skip_trailing_whitespace=false);
        advance(*input);
        hi_1 := read_number(u32, *input, skip_trailing_whitespace=false);
        advance(*input);
        lo_2 := read_number(u32, *input, skip_trailing_whitespace=false);
        advance(*input);
        hi_2 := read_number(u32, *input, skip_trailing_whitespace=true);

        if lo_1 <= lo_2 && hi_1 >= hi_2 || lo_2 <= lo_1 && hi_2 >= hi_1
        {
            contained += 1;
        }

        if hi_1 >= lo_2 && lo_1 <= hi_2
        {
            overlap += 1;
        }
    }

    return tprint("%", contained), tprint("%", overlap);
}