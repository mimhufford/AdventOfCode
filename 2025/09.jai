day9 :: (input: string) -> string, string
{
    part1, part2 : s64;

    points : [..]Point;

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

            if a.x == b.x || a.y == b.y {
                part2 = max(part2, area);
                continue;
            }

            c := Point.{a.x, b.y};
            d := Point.{b.x, a.y};

            if !point_in_polygon(c, points) continue;
            if !point_in_polygon(d, points) continue;
            if !rect_in_polygon(a, b, c, d, points) continue;

            part2 = max(part2, area);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Point :: struct { x, y : s64; }

point_in_polygon :: (p: Point, polygon: []Point) -> bool {
    return false;
}

rect_in_polygon :: (a: Point, b: Point, c: Point, d: Point, polygon: []Point) -> bool {
    return false;
}