day3 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        bank := input;
        bank.count = 100;
        advance(*input, 101);

        part1 += largest_joltage(bank, 2);
        part2 += largest_joltage(bank, 12);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

largest_joltage :: (bank: string, num_batteries: s64) -> s64 {
    joltage := 0;

    tens_digit  := 0;
    tens_index  := 0;
    units_digit := 0;
    units_index := 0;

    for index: 0..bank.count-2 {
        if bank[index] - "0" <= tens_digit continue;
        tens_digit = bank[index] - "0";
        tens_index = index;
        if tens_digit == 9 break;
    }

    joltage *= 10;
    joltage += tens_digit;
    advance(*bank, tens_index+1);

    for index: 0..bank.count-1 {
        if bank[index] - "0" <= units_digit continue;
        units_digit = bank[index] - "0";
        units_index = index;
        if units_digit == 9 break;
    }

    joltage *= 10;
    joltage += units_digit;
    advance(*bank, units_index+1);

    return joltage;
}