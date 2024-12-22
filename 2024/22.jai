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
    val, dif: [4]s64;
    r := seed;

    for 1..2000
    {
        r ^= r * 64;   r %= 16777216;
        r ^= r / 32;   r %= 16777216;
        r ^= r * 2048; r %= 16777216;

        dif[0], dif[1], dif[2], dif[3] = dif[1], dif[2], dif[3], r % 10 - val[3] % 10;
        val[0], val[1], val[2], val[3] = val[1], val[2], val[3], r;

        if it > 3
        {
            seq := (dif[0] + 9) * (19 * 19 * 19);
            seq += (dif[1] + 9) * (19 * 19);
            seq += (dif[2] + 9) * (19);
            seq += (dif[3] + 9) * (1);
            if seen[seq] continue;
            seen[seq] = true;
            price_for_seq[seq] += r % 10;
            best_price = max(best_price, price_for_seq[seq]);
        }
    }

    return val[3];
}