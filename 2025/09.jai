day9 :: (input: string) -> string, string
{
    part1, part2 : s64;

    points : [..] struct { x, y : s64; };
    array_reserve(*points, 500);

    while input {
        p := array_add(*points);
        p.x = read_s64(*input); advance(*input);
        p.y = read_s64(*input);
    }

    for i: 0..points.count-1 {
        for j: i+1..points.count-1 {
            a, b := points[i], points[j];
            area := (abs(a.x - b.x) + 1) * (abs(a.y - b.y) + 1);
            part1 = max(part1, area);

            if area < part2 continue;
            if a.x == b.x || a.y == b.y continue;

            left   := min(a.x, b.x);
            right  := max(a.x, b.x);
            top    := min(a.y, b.y);
            bottom := max(a.y, b.y);

            for 0..points.count-1 {
                l1 := points[it];
                l2 := points[(it + 1) % points.count];
                if l1.x <= left   && l2.x <= left   continue;
                if l1.x >= right  && l2.x >= right  continue;
                if l1.y <= top    && l2.y <= top    continue;
                if l1.y >= bottom && l2.y >= bottom continue;
                continue j;
            }

            part2 = max(part2, area);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}