day1 :: (input: string) -> string, string
{
    totals : [..]u32;

    while input.count
    {
        current_elf_calories : u32;

        while input.count && !is_whitespace(input.data[0])
        {   
            current_elf_calories += read_number(u32, *input, skip_trailing_whitespace=false);
            if input.count advance(*input);
        }

        array_add(*totals, current_elf_calories);
        if input.count advance(*input);
    }

    quick_sort(totals, n => n);

    return tprint("%", totals[totals.count-1]), tprint("%", totals[totals.count-1]+totals[totals.count-2]+totals[totals.count-3]);
}