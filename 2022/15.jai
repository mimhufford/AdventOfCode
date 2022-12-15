day15 :: (input: string) -> string, string
{
    readings : [..]Reading;

    while input
    {
        reading := array_add(*readings);
        for 1..2 read_word(*input);
        advance(*input, 2);
        reading.sensor.x = read_s32(*input);
        advance(*input, 4);
        reading.sensor.y = read_s32(*input);
        for 1..5 read_word(*input);
        advance(*input, 2);
        reading.beacon.x = read_s32(*input);
        advance(*input, 4);
        reading.beacon.y = read_s32(*input);
        reading.dist = manhattan_distance(reading.sensor, reading.beacon);
    }

    quick_sort(readings, (a, b) => manhattan_distance(a.sensor, b.sensor));

    not_beacon_2_000_000 : Table(s32, void);

    for readings
    {
        dx := it.dist - abs(2_000_000 - it.sensor.y);
        if dx < 0 continue;

        for x: it.sensor.x - dx..it.sensor.x + dx
        {
            find_or_add(*not_beacon_2_000_000, x);
        }
    }

    for readings if it.beacon.y == 2_000_000 table_remove(*not_beacon_2_000_000, it.beacon.x);
    

    tuning_frequency := 0;

    for r: readings
    {
        s := r.sensor;
        s.x += r.dist + 1;

        found := false;
        for 0..r.dist { s.x -= 1; s.y -= 1; found, tuning_frequency = search(s); if found break r; }
        for 0..r.dist { s.x -= 1; s.y += 1; found, tuning_frequency = search(s); if found break r; }
        for 0..r.dist { s.x += 1; s.y += 1; found, tuning_frequency = search(s); if found break r; }
        for 0..r.dist { s.x += 1; s.y -= 1; found, tuning_frequency = search(s); if found break r; }
    }

    return tprint("%", not_beacon_2_000_000.count), tprint("%", tuning_frequency);
}

#scope_file

Reading :: struct
{
    sensor : Point;
    beacon : Point;
    dist   : s32;
}

Point :: struct
{
    x, y : s32;
}

manhattan_distance :: (a: Point, b: Point) -> s32
{
    return abs(a.x - b.x) + abs(a.y - b.y);
}

search :: (p: Point) -> bool, s64 #expand
{
    if p.x < 0         return false, 0;
    if p.y < 0         return false, 0;
    if p.x > 4_000_000 return false, 0;
    if p.y > 4_000_000 return false, 0;

    for `readings if manhattan_distance(p, it.sensor) <= it.dist return false, 0;

    return true, (cast(s64)p.x) * 4_000_000 + p.y;
}