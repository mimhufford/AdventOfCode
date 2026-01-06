day10 :: (input: string) -> string, string
{
    points : [..] struct { px, py, vx, vy: s64; };

    u, d := 0;
    while input {
        p := array_add(*points);
        p.px = get(s64, *input);
        p.py = get(s64, *input);
        p.vx = get(s64, *input);
        p.vy = get(s64, *input);
        advance(*input, 2);
        if p.py < 0 u = points.count - 1;
        if p.py > 0 d = points.count - 1;
    }

    p := abs(points[u].py - points[d].py);
    v := abs(points[u].vy - points[d].vy);
    part2 := ((p - 10) / v) - 1;

    grid : [10][62]u8;
    for grid for * it it.* = " ";
    while true {
        part2 += 1;
        x1, y1, x2, y2 := S64_MAX, S64_MAX, S64_MIN, S64_MIN;
        for p: points {
            x, y := p.px + part2 * p.vx, p.py + part2 * p.vy;
            x1, y1 = min(x1, x), min(y1, y);
            x2, y2 = max(x2, x), max(y2, y);
        }
        area := (x2 - x1) * (y2 - y1);
        if area > 549 continue;
        for p: points grid[p.py + part2 * p.vy - y1][p.px + part2 * p.vx - x1] = "#";
        break;
    }

    // for grid print("%\n", it.(string));
    part1 := "LRGPBHEZ";

    return part1, tprint("%", part2);
}