day23 :: (input: string) -> string, string
{
    part1, part2 := 0;

    bots : [..] struct { x, y, z, r: s64; };
    strongest_r, strongest_i := 0;

    while input {
        advance(*input, 5);
        b := array_add(*bots);
        b.x = read_s64(*input); advance(*input);
        b.y = read_s64(*input); advance(*input);
        b.z = read_s64(*input); advance(*input, 5);
        b.r = read_s64(*input);
        if b.r <= strongest_r continue;
        strongest_r = b.r;
        strongest_i = bots.count - 1;
    }

    strongest := bots[strongest_i];
    for bots {
        distance := abs(strongest.x - it.x) + abs(strongest.y - it.y) + abs(strongest.z - it.z);
        part1 += ifx distance <= strongest.r then 1; 
    }

    Cube :: struct { x, y, z, r: s64; }

    print :: (c: Cube) {
        x0, x1 := c.x - c.r >> 1, c.x + c.r >> 1;
        y0, y1 := c.y - c.r >> 1, c.y + c.r >> 1;
        z0, z1 := c.z - c.r >> 1, c.z + c.r >> 1;
        print("% %, % %, % %\n", x0,x1,y0,y1,z0,z1);
    }

    divide :: (c: Cube) {
        if c.r == 1 return;

        offset := s64.[-(c.r>>2), c.r>>2];

        for z: offset for y: offset for x: offset {
            n := c;
            n.r >>= 1;
            n.x, n.y, n.z += x, y, z;
            print(n);
        }
    }

    c0 := Cube.{0, 0, 0, 1<<5};

    print(c0);
    divide(c0);

    return tprint("%", part1), tprint("%", part2);
}