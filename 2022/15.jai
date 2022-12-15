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

    not_beacon_2_000_000 : Table(s32, void);

    for 0..sensors.count-1
    {
        s := sensors[it];
        b := beacons[it];
        d := manhattan_distance(s, b);

        dx := d - abs(2_000_000 - s.y);
        if dx < 0 continue;

        for x: s.x - dx..s.x + dx
        {
            find_or_add(*not_beacon_2_000_000, x);
        }
    }

    for beacons if it.y == 2_000_000 table_remove(*not_beacon_2_000_000, it.x);

    return tprint("%", not_beacon_2_000_000.count), tprint("%", "");
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