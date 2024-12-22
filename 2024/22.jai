day22 :: (input: string) -> string, string
{
    buyers: [..]Buyer;
    part1, part2 := 0;

    while input
    {
        buyer := array_add(*buyers);
        buyer.seed = read_s64(*input);
        generate(buyer);
        part1 += buyer.value[2000];
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Buyer :: struct
{
    seed: s64;
    value: [2001]s64;
    diff: [2001]s64;
    seq_to_price: Table(u64, s64);
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
        b.diff[it] = r % 10 - b.value[it-1] % 10;

        if it > 3
        {
            seq := (cast,no_check(u64)(cast(s16)b.diff[it-3])) << (16 * 3)
                 | (cast,no_check(u64)(cast(s16)b.diff[it-2])) << (16 * 2)
                 | (cast,no_check(u64)(cast(s16)b.diff[it-1])) << (16 * 1)
                 | (cast,no_check(u64)(cast(s16)b.diff[it-0])) << (16 * 0);

            s2p, new := find_or_add(*b.seq_to_price, seq);
            if new s2p.* = r % 10;
        }
    }
}