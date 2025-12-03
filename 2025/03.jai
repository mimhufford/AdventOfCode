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

    digit := 0;
    index := 0;
    for 0..bank.count-2 {
        if bank[it] - "0" <= digit continue;
        digit = bank[it] - "0";
        index = it;
        if digit == 9 break;
    }

    joltage *= 10;
    joltage += digit;
    advance(*bank, index + 1);

    digit = 0;
    index = 0;
    for 0..bank.count-1 {
        if bank[it] - "0" <= digit continue;
        digit = bank[it] - "0";
        index = it;
        if digit == 9 break;
    }

    joltage *= 10;
    joltage += digit;
    advance(*bank, index + 1);

    return joltage;
}