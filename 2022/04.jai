day4 :: (input: string) -> string, string
{
    contains := 0;
    overlaps := 0;

    while input.count
    {
        lo_1 := read_number(u32, *input, skip_trailing_whitespace=false);
        advance(*input);
        hi_1 := read_number(u32, *input, skip_trailing_whitespace=false);
        advance(*input);
        lo_2 := read_number(u32, *input, skip_trailing_whitespace=false);
        advance(*input);
        hi_2 := read_number(u32, *input, skip_trailing_whitespace=true);

        contains += cast(s8)(lo_1 <= lo_2 && hi_1 >= hi_2 || lo_2 <= lo_1 && hi_2 >= hi_1);
        overlaps += cast(s8)(hi_1 >= lo_2 && lo_1 <= hi_2);
    }

    return tprint("%", contains), tprint("%", overlaps);
}