day6 :: (input: string) -> string, string
{
    part1, part2 := 0;

    coords : [..] struct { x, y: s32; };
    xmin, ymin, xmax, ymax := S32_MAX, S32_MAX, S32_MIN, S32_MIN;

    while input {
        c := array_add(*coords);
        c.x = read_s32(*input);
        advance(*input, 2);
        c.y = read_s32(*input);

        xmin, ymin = min(xmin, c.x), min(ymin, c.y);
        xmax, ymax = max(xmax, c.x), max(ymax, c.y);
    }

    counts : Table(s16, struct { edge: bool; count: s32; });

    for y: ymin..ymax {
        for x: xmin..xmax {
            total_distance := 0;
            best_id, best_dist := S16_MAX;
            for c, id: coords {
                dist := abs(x - c.x) + abs(y - c.y);
                total_distance += dist;
                if dist == best_dist { best_id, best_dist = S16_MAX; continue; }
                if dist <  best_dist { best_id, best_dist = id.(s16), dist.(s16); continue; }
            }
            entry := find_or_add(*counts, best_id);
            entry.count += 1;
            entry.edge |= x == xmin || x == xmax || y == ymin || y == ymax;
            part2 += ifx total_distance < 10000 then 1;
        }
    }

    for counts if !it.edge part1 = max(part1, it.count);

    return tprint("%", part1), tprint("%", part2);
}