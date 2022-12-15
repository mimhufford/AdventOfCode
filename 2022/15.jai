day15 :: (input: string) -> string, string
{
    readings  := parse_readings(input);
    negatives := count_negatives_on_row(readings, 2_000_000);
    frequency := find_beacon(readings);

    return tprint("%", negatives), tprint("%", frequency);
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

count_negatives_on_row :: (readings: []Reading, row: s32) -> s64
{
    negatives : Table(s32, void);

    for readings
    {
        dx := it.dist - abs(row - it.sensor.y);
        if dx < 0 continue;

        for x: it.sensor.x - dx..it.sensor.x + dx
        {
            find_or_add(*negatives, x);
        }
    }

    for readings if it.beacon.y == 2_000_000 table_remove(*negatives, it.beacon.x);
    
    return negatives.count;
}

find_beacon :: (readings: []Reading) -> s64
{
    for r: readings
    {
        s := r.sensor;
        s.x += r.dist + 1;

        for 0..r.dist { s.x -= 1; s.y -= 1; found, freq := search(s); if found return freq; }
        for 0..r.dist { s.x -= 1; s.y += 1; found, freq := search(s); if found return freq; }
        for 0..r.dist { s.x += 1; s.y += 1; found, freq := search(s); if found return freq; }
        for 0..r.dist { s.x += 1; s.y -= 1; found, freq := search(s); if found return freq; }

        search :: (p: Point) -> bool, s64 #expand
        {
            if p.x < 0         return false, 0;
            if p.y < 0         return false, 0;
            if p.x > 4_000_000 return false, 0;
            if p.y > 4_000_000 return false, 0;

            for `readings if manhattan_distance(p, it.sensor) <= it.dist return false, 0;

            return true, (cast(s64)p.x) * 4_000_000 + p.y;
        }
    }

    assert(false);
    return 0;
}

manhattan_distance :: (a: Point, b: Point) -> s32
{
    return abs(a.x - b.x) + abs(a.y - b.y);
}

parse_readings :: (input: string) -> [..]Reading
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

    return readings;
}