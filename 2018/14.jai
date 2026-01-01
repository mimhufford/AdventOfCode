day14 :: (input: string) -> string, string
{
    part1, part2 := 0;
    key := read_s64(*input);
    e0, e1, last10 := 0, 1, 0;
    scores : [..]u8;
    array_reserve(*scores, 25_000_000);
    array_add(*scores, 3, 7);

    while true {
        a, b := scores[e0], scores[e1];
        n0, n1 := (a + b) / 10, (a + b) % 10;
        if n0   { array_add(*scores, n0); last10 = last10 * 10 + n0; }
        if true { array_add(*scores, n1); last10 = last10 * 10 + n1; }
        last10 %= 10000000000;
        e0 = (e0 + a + 1) % scores.count;
        e1 = (e1 + b + 1) % scores.count;

        // print("% % ", formatInt(it - 1, minimum_digits=2), formatInt(last10 % 100000, minimum_digits=5));
        // for scores {
            // if it_index == e0 print("(%)", it);
            // else if it_index == e1 print("[%]", it);
            // else print(" % ", it);
        // }
        // print("\n");

        if scores.count > 24_000_000 break;

        if scores.count == key + 10 then part1 = last10;
        if last10 % 1000000 != key continue;
        part2 = scores.count;
        break;
    }

    return tprint("%", part1), tprint("%", part2);
}