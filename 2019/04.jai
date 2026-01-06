day4 :: (input: string) -> string, string
{
    part1, part2 := 0;

    pass := get(u64, *input).(s64);
    stop := get(u64, *input).(s64);

    while true {
        pass += 1;
        digits : [6]u8;
        for 0..5 { digits[5-it] = (pass % 10).(u8); pass /= 10; }
        for 0..4 {
            if digits[it+1] >= digits[it] continue;
            for i: it+1..5 digits[i] = digits[it];
            break;
        }
        for digits pass = pass * 10 + it;
        if pass > stop break;

        rule1 := false;
        for 0..4 rule1 |= digits[it] == digits[it+1];

        rule2 := (digits[0] == digits[1] && digits[1] != digits[2]) ||
                 (digits[0] != digits[1] && digits[1] == digits[2] && digits[2] != digits[3]) ||
                 (digits[1] != digits[2] && digits[2] == digits[3] && digits[3] != digits[4]) ||
                 (digits[2] != digits[3] && digits[3] == digits[4] && digits[4] != digits[5]) ||
                 (digits[3] != digits[4] && digits[4] == digits[5]);

        part1, part2 += ifx rule1 then 1, ifx rule2 then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}