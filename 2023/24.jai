day24 :: (input: string) -> string, string
{
    hailstones : [..]Hailstone;

    for split(trim(input), "\n")
    {
        h := array_add(*hailstones);
        h.p.x = read_s64(*it); advance(*it, 2);
        h.p.y = read_s64(*it); advance(*it, 2);
        h.p.z = read_s64(*it); advance(*it, 2);
        h.v.x = read_s64(*it); advance(*it, 2);
        h.v.y = read_s64(*it); advance(*it, 2);
        h.v.z = read_s64(*it);
    }

    part1, part2 := 0;

    for i: 0..hailstones.count-1
    {
        h1 := hailstones[i];
        x1 := h1.p.x;
        x2 := h1.v.x + x1;
        y1 := h1.p.y;
        y2 := h1.v.y + y1;

        for j: i+1..hailstones.count-1
        {
            h2 := hailstones[j];
            x3 := h2.p.x;
            x4 := h2.v.x + x3;
            y3 := h2.p.y;
            y4 := h2.v.y + y3;

            denominator := ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4));
            if denominator == 0 continue;
            x := ((x1*y2 - y1*x2) * (x3 - x4) - (x1 - x2) * (x3*y4 - y3*x4)) / denominator;
            y := ((x1*y2 - y1*x2) * (y3 - y4) - (y1 - y2) * (x3*y4 - y3*x4)) / denominator;

            lo := 200000000000000;
            hi := 400000000000000;
            if x < lo continue;
            if y < lo continue;
            if x > hi continue;
            if y > hi continue;

            part1 += 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

V3 :: struct
{
    x, y, z : s64;
}

Hailstone :: struct
{
    p, v : V3;
}