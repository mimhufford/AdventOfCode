day2 :: (input: string) -> string, string
{
    part1, part2 : s64;
    used : [..]s64;

    while input {
        array_reset_keeping_memory(*used);
        lo := read_s64(*input);
        advance(*input);
        hi := read_s64(*input);
        if input advance(*input);

        for digit_count: floor_log_10(lo)..floor_log_10(hi) {
            for part_count: 2..digit_count {
                if digit_count % part_count continue;
                part_size := digit_count / part_count;

                for part: pow_10[part_size - 1]..pow_10[part_size] - 1 {
                    n := 0;
                    for 1..part_count {
                        n *= pow_10[part_size];
                        n += part;
                    }

                    if n < lo continue;
                    if n > hi break;
                    if !array_add_if_unique(*used, n) continue;

                    part1 += ifx part_count == 2 then n;
                    part2 += n;
                }
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

floor_log_10 :: (n: s64) -> s64 {
    if n < 10 return 1;
    if n < 100 return 2;
    if n < 1000 return 3;
    if n < 10000 return 4;
    if n < 100000 return 5;
    if n < 1000000 return 6;
    if n < 10000000 return 7;
    if n < 100000000 return 8;
    if n < 1000000000 return 9;
    if n < 10000000000 return 10;
    if n < 100000000000 return 11;
    if n < 1000000000000 return 12;
    return 0;
}

pow_10 :: s64.[1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1000000000000];