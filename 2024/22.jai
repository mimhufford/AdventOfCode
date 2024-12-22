day22 :: (input: string) -> string, string
{
    buyers: [..]Buyer;
    part1, part2 := 0;

    seq_accum: Table(u64, s64);

    while input
    {
        buyer := array_add(*buyers);
        buyer.seed = read_s64(*input);
        generate(buyer);
        part1 += buyer.value[2000];
        for buyer.seq_to_price
        {
            s2p := find_or_add(*seq_accum, it_index);
            s2p.* += it;
            part2 = max(part2, s2p.*);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Buyer :: struct
{
    seed: s64;
    value: [2001]s64;
    diff: [2001]s16;
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
        b.diff[it] = cast(s16)(r % 10 - b.value[it-1] % 10);

        if it > 3
        {
            seq : struct { v: [4]s16; #place v; hash: u64; };
            seq.v[0] = b.diff[it-3];
            seq.v[1] = b.diff[it-2];
            seq.v[2] = b.diff[it-1];
            seq.v[3] = b.diff[it-0];
            s2p, new := find_or_add(*b.seq_to_price, seq.hash);
            if new s2p.* = r % 10;
        }
    }
}