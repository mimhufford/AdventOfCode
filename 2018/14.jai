day14 :: (input: string) -> string, string
{
    part1, part2 := 0;
    key := get(s64, *input);
    e0, e1, last10 := 0, 1, 0;
    scores : [..]u8;
    array_reserve(*scores, 25_000_000);
    array_add(*scores, 3, 7);

    while !part2 {
        s0, s1 := (scores[e0] + scores[e1]) / 10, (scores[e0] + scores[e1]) % 10;
        add :: (s: u8) #expand {
            array_add(*scores, s);
            last10 = (last10 * 10 + s) % 10000000000;
            if last10 % 1000000 == key  then part2 = scores.count - 6;
            if scores.count == key + 10 then part1 = last10;
        }
        if s0   add(s0);
        if true add(s1);
        e0 = (e0 + scores[e0] + 1) % scores.count;
        e1 = (e1 + scores[e1] + 1) % scores.count;
    }

    return tprint("%", part1), tprint("%", part2);
}