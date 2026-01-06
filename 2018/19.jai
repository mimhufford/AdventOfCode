day19 :: (input: string) -> string, string
{
    for 1..65 get(u8, *input);
    a := get(u8, *input);
    for 1..5 get(u8, *input);
    b := get(u8, *input);

    base := 22 * a + b;

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