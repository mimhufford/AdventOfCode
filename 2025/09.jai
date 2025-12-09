day9 :: (input: string) -> string, string
{
    part1, part2 : s64;

    points : [..] struct { x, y : s64; };

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
        }
    }

    return tprint("%", part1), tprint("%", part2);
}