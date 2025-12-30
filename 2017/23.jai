day23 :: (input: string) -> string, string
{
    for 1..2 read_word(*input);
    key := read_s64(*input);

    part1 := (key - 2) * (key - 2);
    part2 := 0;
    key = 100000 + 100 * key;

    for it: 0..1000 {
        defer key += 17;
        if key % 2 == 0 { part2 += 1; continue it; }
        i := 3;
        while i * i <= key {
            if key % i == 0 { part2 += 1; continue it; }
            i += 2;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}