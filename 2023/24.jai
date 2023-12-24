day24 :: (input: string) -> string, string
{
    hailstones : [..]Hailstone;

    for split(trim(input), "\n")
    {
        h := array_add(*hailstones);
        h.p.x = xx read_u64(*it); advance(*it, 2);
        h.p.y = xx read_u64(*it); advance(*it, 2);
        h.p.z = xx read_u64(*it); advance(*it, 2);
        h.v.x = xx read_s64(*it); advance(*it, 2);
        h.v.y = xx read_s64(*it); advance(*it, 2);
        h.v.z = xx read_s64(*it);
    }

    part1, part2 := 0;

    for i: 0..hailstones.count-1
    {
        h1 := hailstones[i];
        s1 := h1.v.y / h1.v.x;

        for j: i+1..hailstones.count-1
        {
            h2 := hailstones[j];
            s2 := h2.v.y / h2.v.x;

            if s1 == s2 continue; // parallel

            lo := cast(float)200000000000000;
            hi := cast(float)400000000000000;

            x := ((s2 * h2.p.x) - (s1 * h1.p.x) + h1.p.y - h2.p.y) / (s2 - s1);
            if x < lo || x > hi continue; // out of range

            y := s1 * (x - h1.p.x) + h1.p.y;
            if y < lo || y > hi continue; // out of range

            if (x - h1.p.x) / h1.v.x < 0 continue; // backward in time
            if (x - h2.p.x) / h2.v.x < 0 continue; // backward in time

            part1 += 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Hailstone :: struct
{
    p, v : Vector3;
}