day22 :: (input: string) -> string, string
{
    part1 := 0;
    while input part1 += generate(read_s64(*input));
    part2 := best_price;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

best_price := 0;
price_for_seq : [19*19*19*19]u16;
seen : [19*19*19*19]bool;

generate :: (seed: s64) -> s64
{
    memset(seen.data, 0, 19*19*19*19);
    v1, v2, v3, v4 := 0, 0, 0, seed;
    d1, d2, d3, d4 := 0, 0, 0, 0;

    for 1..2000
    {
        v1, v2, v3 = v2, v3, v4;
        v4 ^= v4 << 6;  v4 &= 0xFFFFFF;
        v4 ^= v4 >> 5;  v4 &= 0xFFFFFF;
        v4 ^= v4 << 11; v4 &= 0xFFFFFF;
        d1, d2, d3, d4 = d2, d3, d4, (v4 % 10 - v3 % 10) + 9;

        if it > 3
        {
            seq := d1*19*19*19 + d2*19*19 + d3*19 + d4;
            if seen[seq] continue;
            seen[seq] = true;
            price_for_seq[seq] += xx (v4 % 10);
            best_price = max(best_price, price_for_seq[seq]);
        }
    }

    return v4;
}