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

    part1 := 0;

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

    potential_x_set : [..]s64;
    potential_y_set : [..]s64;
    potential_z_set : [..]s64;

    for i: 0..hailstones.count-1
    {
        for j: i+1..hailstones.count-1
        {
            a := hailstones[i];
            b := hailstones[j];

            find_possible_for_axis :: (possibilities: *[..]s64, p1: float64, p2: float64, v1: float64, v2: float64)
            {
                if v1 != v2 return;
                if abs(v1) <= 100 return;

                set : [..]s64;
                difference := cast(s64)p2 - cast(s64)p1;
                for v: -1000..1000
                {
                    if v == cast(s64)v1 continue;
                    if difference % (v-cast(s64)v1) != 0 continue;
                    array_add(*set, v);
                }

                if possibilities.count == 0 for set array_add(possibilities, it);
                else for * possibilities.* if array_find(set, it.*) == false remove it;
            }

            find_possible_for_axis(*potential_x_set, a.p.x, b.p.x, a.v.x, b.v.x);
            find_possible_for_axis(*potential_y_set, a.p.y, b.p.y, a.v.y, b.v.y);
            find_possible_for_axis(*potential_z_set, a.p.z, b.p.z, a.v.z, b.v.z);
        }
    }

    part2 := 0;

    {
        r : Hailstone;
        r.v.x, r.v.y, r.v.z = xx potential_x_set[0], xx potential_y_set[0], xx potential_z_set[0];
        a, b := hailstones[0], hailstones[1];
        ma := (a.v.y-r.v.y)/(a.v.x-r.v.x);
        mb := (b.v.y-r.v.y)/(b.v.x-r.v.x);
        ca := a.p.y - (ma*a.p.x);
        cb := b.p.y - (mb*b.p.x);
        x := cast(s64)((cb-ca)/(ma-mb));
        y := cast(s64)(ma*x + ca);
        time := (x - cast(s64)a.p.x) / (cast(s64)a.v.x-cast(s64)r.v.x);
        z := cast(s64)a.p.z + (cast(s64)a.v.z - cast(s64)r.v.z)*time;
        part2 = x + y + z;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

V3 :: struct
{
    x, y, z : float64;
}

Hailstone :: struct
{
    p, v : V3;
}