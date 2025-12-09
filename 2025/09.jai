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

            if rect_in_polygon(a, b, points) {
                part2 = max(part2, area);
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Point :: struct { x, y : s64; }

rect_in_polygon :: (corner1: Point, corner2: Point, points: []Point) -> bool {
    left   := min(corner1.x, corner2.x);
    right  := max(corner1.x, corner2.x);
    top    := min(corner1.y, corner2.y);
    bottom := max(corner1.y, corner2.y);

    for 0..points.count-1 {
        a := points[it];
        b := points[(it + 1) % points.count];
        if a.x <= left   && b.x <= left   continue;
        if a.x >= right  && b.x >= right  continue;
        if a.y <= top    && b.y <= top    continue;
        if a.y >= bottom && b.y >= bottom continue;
        return false;
    }

    return true;
}