day23 :: (input: string) -> string, string
{
    part1, part2 := 0;

    bots : [..] struct { x, y, z, r: s64; };
    strongest_r, strongest_i := 0;

    while input {
        b := array_add(*bots);
        b.x = get(s64, *input);
        b.y = get(s64, *input);
        b.z = get(s64, *input);
        b.r = get(s64, *input);
        if b.r <= strongest_r continue;
        strongest_r, strongest_i = b.r, bots.count - 1;
    }

    strongest := bots[strongest_i];
    for bots {
        distance := abs(strongest.x - it.x) + abs(strongest.y - it.y) + abs(strongest.z - it.z);
        part1 += ifx distance <= strongest.r then 1; 
    }

    curr, next : [..] struct { x, y, z, count: s64; r := 1<<32; };
    array_add(*curr);
    for pass: 0..32 {
        most := 0;
        while curr {
            c := pop(*curr);

            offset := s64.[-(c.r>>2), c.r>>2];

            for z: offset for y: offset for x: offset {
                n := array_add(*next);
                n.r = c.r >> 1;
                n.x, n.y, n.z = c.x+x, c.y+y, c.z+z;

                x0, x1 := n.x - n.r >> 1, n.x + n.r >> 1;
                y0, y1 := n.y - n.r >> 1, n.y + n.r >> 1;
                z0, z1 := n.z - n.r >> 1, n.z + n.r >> 1;

                for b: bots {
                    x := min(x1, max(b.x, x0));
                    y := min(y1, max(b.y, y0));
                    z := min(z1, max(b.z, z0));
                    d := abs(x - b.x) + abs(y - b.y) + abs(z - b.z);
                    n.count += ifx d <= b.r then 1;
                }
                most = max(most, n.count);
            }
        }

        part2 = S64_MAX;
        for next if it.count < most remove it;
        for next part2 = min(part2, abs(it.x) + abs(it.y) + abs(it.z));
        curr, next = next, curr;
    }

    return tprint("%", part1), tprint("%", part2);
}