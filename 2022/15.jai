day15 :: (input: string) -> string, string
{
    sensors : [..]Point;
    beacons : [..]Point;

    while input
    {
        for 1..2 read_word(*input);
        advance(*input, 2);
        sx := read_s32(*input);
        advance(*input, 4);
        sy := read_s32(*input);
        array_add(*sensors, .{sx, sy});
        for 1..5 read_word(*input);
        advance(*input, 2);
        bx := read_s32(*input);
        advance(*input, 4);
        by := read_s32(*input);
        array_add(*beacons, .{bx, by});
    }

    for 0..sensors.count-1
    {
        s := sensors[it];
        b := beacons[it];
        d := manhattan_distance(s, b);

        if abs(2_000_000 - s.y) < d
        {
            // this pair has some places on y=2_000_000 that are definitely not beacon
        }
    }

    return tprint("%", ""), tprint("%", "");
}

#scope_file

Point :: struct
{
    x, y : s32;
    #place x;
    hash : u64;
}

manhattan_distance :: (a: Point, b: Point) -> s32
{
    return abs(a.x - b.x) + abs(a.y - b.y);
}