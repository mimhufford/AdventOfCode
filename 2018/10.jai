day10 :: (input: string) -> string, string
{
    points : [..] struct { px, py, vx, vy: s64; };

    while input {
        p := array_add(*points);
        advance(*input, 10); skip_whitespace(*input); p.px = read_s64(*input);
        advance(*input, 2);  skip_whitespace(*input); p.py = read_s64(*input);
        advance(*input, 12); skip_whitespace(*input); p.vx = read_s64(*input);
        advance(*input, 2);  skip_whitespace(*input); p.vy = read_s64(*input);
        advance(*input, 2);
    }

    part2 := 0;
    grid : [10][62]u8;
    for grid for * it it.* = " ";
    for second: 1..S64_MAX {
        x1, y1, x2, y2 := S64_MAX, S64_MAX, S64_MIN, S64_MIN;
        for p: points {
            x, y := p.px + second * p.vx, p.py + second * p.vy;
            x1, y1 = min(x1, x), min(y1, y);
            x2, y2 = max(x2, x), max(y2, y);
        }
        area := (x2 - x1) * (y2 - y1);
        if area > 549 continue;
        for p: points grid[p.py + second * p.vy - y1][p.px + second * p.vx - x1] = "#";
        part2 = second;
        break;
    }

    // for grid print("%\n", it.(string));
    part1 := "LRGPBHEZ";

    return part1, tprint("%", part2);
}