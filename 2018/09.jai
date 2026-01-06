day9 :: (input: string) -> string, string
{
    part1, part2 := 0;
    players := get(s64, *input);
    rounds  := get(s64, *input);

    Marble :: struct { i: s64; p, n: *Marble; }
    scores := NewArray(players, s64);
    marbles : [..]Marble;
    array_reserve(*marbles, 7_500_000);
    c := array_add(*marbles);
    c.p, c.n = c;

    for i: 1..rounds*100 {
        if i % 23 == 0 {
            d := c.p.p.p.p.p.p.p;
            c, d.p.n = d.n;
            scores[i % players] += i + d.i;
            part1 = ifx i <= rounds then max(part1, scores[i % players]) else part1;
            part2 = max(part2, scores[i % players]);
        } else {
            m := array_add(*marbles);
            m.i = i;
            a, b := c.n, c.n.n;
            a.n, b.p = m;
            m.n, m.p = b, a;
            c = m;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}