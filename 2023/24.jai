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

            if a.v.x == b.v.x && abs(a.v.x) > 100
            {
                new_x_set : [..]s64;
                difference := cast(s64)b.p.x - cast(s64)a.p.x;
                for v: -1000..1000
                {
                    if v == cast(s64)a.v.x continue;
                    if difference % (v-cast(s64)a.v.x) == 0
                    {
                        array_add(*new_x_set, v);
                    }
                }

                if potential_x_set.count == 0
                {
                    for new_x_set array_add(*potential_x_set, it);
                }
                else
                {
                    for * potential_x_set
                    {
                        if array_find(new_x_set, it.*) == false remove it;
                    }
                }
            }
            if a.v.y == b.v.y && abs(a.v.y) > 100
            {
                new_y_set : [..]s64;
                difference := cast(s64)b.p.y - cast(s64)a.p.y;
                for v: -1000..1000
                {
                    if v == cast(s64)a.v.y continue;
                    if difference % (v-cast(s64)a.v.y) == 0
                    {
                        array_add(*new_y_set, v);
                    }
                }

                if potential_y_set.count == 0
                {
                    for new_y_set array_add(*potential_y_set, it);
                }
                else
                {
                    for * potential_y_set
                    {
                        if array_find(new_y_set, it.*) == false remove it;
                    }
                }
            }
            if a.v.z == b.v.z && abs(a.v.z) > 100
            {
                new_z_set : [..]s64;
                difference := cast(s64)b.p.z - cast(s64)a.p.z;
                for v: -1000..1000
                {
                    if v == cast(s64)a.v.z continue;
                    if difference % (v-cast(s64)a.v.z) == 0
                    {
                        array_add(*new_z_set, v);
                    }
                }

                if potential_z_set.count == 0
                {
                    for new_z_set array_add(*potential_z_set, it);
                }
                else
                {
                    for * potential_z_set
                    {
                        if array_find(new_z_set, it.*) == false remove it;
                    }
                }
            }
        }
    }

    part2 := 0;

    {
        RVX, RVY, RVZ := potential_x_set[0], potential_y_set[0], potential_z_set[0];
        a, b := hailstones[0], hailstones[1];
        MA := (a.v.y-RVY)/(a.v.x-RVX);
        MB := (b.v.y-RVY)/(b.v.x-RVX);
        CA := a.p.y - (MA*a.p.x);
        CB := b.p.y - (MB*b.p.x);
        XPos := cast(s64)((CB-CA)/(MA-MB));
        YPos := cast(s64)(MA*XPos + CA);
        Time := (XPos - cast(s64)a.p.x) / (cast(s64)a.v.x-RVX);
        ZPos := cast(s64)a.p.z + (cast(s64)a.v.z - RVZ)*Time;
        part2 = XPos + YPos + ZPos;
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