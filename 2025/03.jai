day3 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        part1 += largest_joltage(slice(input, 0, 100), 2);
        part2 += largest_joltage(slice(input, 0, 100), 12);
        advance(*input, 101);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

largest_joltage :: (bank: string, num_batteries: s64) -> s64 {
    joltage := 0;

    for < battery: 1..num_batteries {
        digit, index := 0;

        for 0..bank.count-battery {
            if bank[it] - "0" <= digit continue;
            digit = bank[it] - "0";
            index = it;
            if digit == 9 break;
        }

        joltage = joltage * 10 + digit;
        advance(*bank, index + 1);
    }

    return joltage;
}