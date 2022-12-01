day1 :: (input: string) -> string, string
{
    totals : [..]u32;

    while input.count
    {
        current_elf_calories : u32;

        while input.count && !is_whitespace(input.data[0])
        {   
            current_elf_calories += read_number(*input);
        }

        array_add(*totals, current_elf_calories);
        if input.count advance(*input);
    }

    quick_sort(totals, n => n);

    return tprint("%", totals[totals.count-1]), tprint("%", totals[totals.count-1]+totals[totals.count-2]+totals[totals.count-3]);
}

#scope_file

read_number :: (s: *string) -> u32
{
    num : u32;
    
    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count && is_whitespace(s.data[0])
    {
        advance(s);
    }

    return num;
}