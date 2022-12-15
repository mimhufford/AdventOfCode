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
    ranges : [..]Point;
    min_x := S32_MAX;
    max_x := S32_MIN;

    for readings
    {
        dx := it.dist - abs(row - it.sensor.y);
        if dx < 0 continue;
        r := array_add(*ranges);
        r.x = it.sensor.x - dx;
        r.y = it.sensor.x + dx;
        min_x = min(min_x, r.x);
        max_x = max(max_x, r.y);
    }

    // TODO: try to collapse and merge ranges to avoid this mess

    count := 0;

    for x: min_x..max_x
    {
        for readings if it.beacon.y == row && it.beacon.x == x continue x;
        for ranges   if it.x <= x && x <= it.y { count +=1; continue x; }
    }
    
    return count;
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