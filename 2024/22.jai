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
    v1, v2, v3, v4, d1, d2, d3, d4 := 0;
    v4 = seed;

    for 1..2000
    {
        r := v4;
        r ^= r * 64;   r %= 16777216;
        r ^= r / 32;   r %= 16777216;
        r ^= r * 2048; r %= 16777216;

        d1, d2, d3, d4 = d2, d3, d4, r % 10 - v4 % 10;
        v1, v2, v3, v4 = v2, v3, v4, r;

        if it > 3
        {
            seq := (d1 + 9) * (19 * 19 * 19);
            seq += (d2 + 9) * (19 * 19);
            seq += (d3 + 9) * (19);
            seq += (d4 + 9) * (1);
            if seen[seq] continue;
            seen[seq] = true;
            price_for_seq[seq] += r % 10;
            best_price = max(best_price, price_for_seq[seq]);
        }
    }

    return v4;
}