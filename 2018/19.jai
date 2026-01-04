day19 :: (input: string) -> string, string
{
    program : [..]u8;
    advance(*input, 6);
    while input {
        read_word(*input);
        read_u8(*input);
        array_add(*program, read_u8(*input));
        read_u8(*input);
    }

    base := 22 * program[21] + program[23];

    sum_factors :: (n: s64) -> s64 {
        result := 1 + n;
        limit := sqrt(n.(float64)).(s64);
        for i: 2..limit if n % i == 0 result += i + n / i;
        return result;
    }

    part1 := sum_factors(base + 836);
    part2 := sum_factors(base + 10551236);

    return tprint("%", part1), tprint("%", part2);
}