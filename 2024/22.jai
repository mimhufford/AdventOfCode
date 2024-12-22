day22 :: (input: string) -> string, string
{
    part1 := 0;
    while input part1 += generate(read_s64(*input));
    part2 := best_price;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

best_price := 0;
price_for_seq : [19*19*19*19]s64;
seen : [19*19*19*19]bool;

generate :: (seed: s64) -> s64
{
    memset(seen.data, 0, 19*19*19*19);
    value: [2001]s64;
    diff: [2001]s64;
    value[0] = seed;

    for 1..2000
    {
        r := value[it-1];
        r ^= r * 64;   r %= 16777216;
        r ^= r / 32;   r %= 16777216;
        r ^= r * 2048; r %= 16777216;

        value[it] = r;
        diff[it] = cast(s16)(r % 10 - value[it-1] % 10);

        if it > 3
        {
            seq := diff[it-3] + 9; seq *= 19;
            seq += diff[it-2] + 9; seq *= 19;
            seq += diff[it-1] + 9; seq *= 19;
            seq += diff[it-0] + 9;
            if seen[seq] continue;
            seen[seq] = true;
            price_for_seq[seq] += r % 10;
            best_price = max(best_price, price_for_seq[seq]);
        }
    }

    return value[2000];
}