day22 :: (input: string) -> string, string
{
    part1 := 0;

    while input
    {
        buyer := Buyer.{ seed = read_s64(*input) };
        generate(*buyer);
        part1 += buyer.value[2000];
    }

    part2 := best_price;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

best_price := 0;
seq_to_price : [19*19*19*19]s64;
seen : [19*19*19*19]bool;

Buyer :: struct
{
    seed: s64;
    value: [2001]s64;
    diff: [2001]s16;
}

generate :: (b: *Buyer)
{
    memset(seen.data, 0, 19*19*19*19);
    b.value[0] = b.seed;

    for 1..2000
    {
        r := b.value[it-1];
        r ^= r * 64;
        r %= 16777216;
        r ^= r / 32;
        r %= 16777216;
        r ^= r * 2048;
        r %= 16777216;

        b.value[it] = r;
        b.diff[it] = cast(s16)(r % 10 - b.value[it-1] % 10);

        if it > 3
        {
            key := 0;
            key += (b.diff[it-3] + 9); key *= 19;
            key += (b.diff[it-2] + 9); key *= 19;
            key += (b.diff[it-1] + 9); key *= 19;
            key += (b.diff[it-0] + 9);
            if seen[key] continue;
            seen[key] = true;
            seq_to_price[key] += r % 10;
            best_price = max(best_price, seq_to_price[key]);
        }
    }
}