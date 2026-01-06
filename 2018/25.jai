day25 :: (input: string) -> string, string
{
    part1 := 0;

    points, queue : [..] struct { x,y,z,w : s64; };

    while input {
        p := array_add(*points);
        p.x = get(s64, *input);
        p.y = get(s64, *input);
        p.z = get(s64, *input);
        p.w = get(s64, *input);
    }

    while points {
        part1 += 1;
        array_add(*queue, pop(*points));
        while queue {
            c := pop(*queue);
            for p: points {
                if abs(c.x-p.x) + abs(c.y-p.y) + abs(c.z-p.z) + abs(c.w-p.w) > 3 continue;
                array_add(*queue, p);
                remove p;
            }
        }
    }

    return tprint("%", part1), ":)";
}