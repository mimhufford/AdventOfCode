day22 :: (input: string) -> string, string
{
    price_for_seq, last_update : [19*19*19*19]u16;
    part1, part2, index := 0;

    while input
    {
        index += 1;
        d1, d2, d3, d4, v3, v4 := 0, 0, 0, 0, 0, read_s64(*input);

        for 1..2000
        {
            v3 = v4;
            v4 ^= v4 << 6;  v4 &= 0xFFFFFF;
            v4 ^= v4 >> 5;
            v4 ^= v4 << 11; v4 &= 0xFFFFFF;
            d1, d2, d3, d4 = d2, d3, d4, (v4 % 10 - v3 % 10) + 9;

            seq := d1*19*19*19 + d2*19*19 + d3*19 + d4;
            if last_update[seq] == index continue;
            last_update[seq] = xx index;
            price_for_seq[seq] += xx (v4 % 10);
            part2 = max(part2, price_for_seq[seq]);
        }

        part1 += v4;
    }

    return tprint("%", part1), tprint("%", part2);
}