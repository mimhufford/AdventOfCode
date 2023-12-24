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