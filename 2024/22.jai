day22 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        buyer := Buyer.{ seed = read_s64(*input) };
        generate(*buyer);
        part1 += buyer.value[2000];
        for buyer.seq_to_price
        {
            seq_to_price[it_index] += it;
            part2 = max(part2, seq_to_price[it_index]);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

seq_to_price : [19*19*19*19]s64;
Buyer :: struct
{
    seed: s64;
    value: [2001]s64;
    diff: [2001]s16;
    seq_to_price: Table(s64, s64);
}

generate :: (b: *Buyer)
{
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
            s2p, new := find_or_add(*b.seq_to_price, key);
            if new s2p.* = r % 10;
        }
    }
}