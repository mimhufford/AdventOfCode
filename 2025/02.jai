day2 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        lo := read_s64(*input);
        advance(*input);
        hi := read_s64(*input);
        if input advance(*input);
    
        for n: lo..hi {
            digits := floor_log_10(n);

            if digits % 2 == 0 {
                b := pow_10(digits / 2);
                left := n / b;
                right := n % b;
                if left == right then part1 += n;
            }

            for base: 1..digits/2 {
                if digits % base continue;
                b := pow_10(base);
                right := n % b;
                part := n / b;
                while part {
                    if part % b != right continue base;
                    part /= b;
                }

                part2 += n;
                break;
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

pow_10 :: (n: s64) -> s64 {
    return s64.[1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1000000000000][n];
}