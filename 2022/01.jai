day1 :: (input: string) -> string, string
{
    m1, m2, m3 : s32;

    while input.count
    {
        current_elf_calories : s32;

        while input.count && !is_whitespace(input.data[0])
        {   
            current_elf_calories += read_number(s32, *input, skip_trailing_whitespace=false);
            if input.count advance(*input);
        }

        if input.count advance(*input);

        if      current_elf_calories > m1   m3, m2, m1 = m2, m1, current_elf_calories;
        else if current_elf_calories > m2   m3, m2, m1 = m2, current_elf_calories, m1;
        else if current_elf_calories > m3   m3, m2, m1 = current_elf_calories, m2, m1;
    }

    return tprint("%", m1), tprint("%", m1 + m2 + m3);
}