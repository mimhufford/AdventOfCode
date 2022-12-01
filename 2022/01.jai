day1 :: (input: string) -> string, string
{
    totals : [..]s32;

    while input.count
    {
        current_elf_calories : s32;

        while input.count && !is_whitespace(input.data[0])
        {   
            current_elf_calories += read_number(s32, *input, skip_trailing_whitespace=false);
            if input.count advance(*input);
        }

        array_add(*totals, current_elf_calories);
        if input.count advance(*input);
    }

    quick_sort(totals, n => -n);

    return tprint("%", totals[0]), tprint("%", totals[0] + totals[1] + totals[2]);
}