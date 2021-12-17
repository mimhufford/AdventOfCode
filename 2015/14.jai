day14 :: (data: string) -> string, string
{
    reindeers : [..]Reindeer;

    while data.count array_add(*reindeers, read_reindeer(*data));

    furthest := 0;

    for reindeers
    {
        seconds :: 2503;
        full_cycle := it.time + it.rest;
        num_full_cycles := seconds / full_cycle;
        remaining_seconds := seconds % full_cycle;
        distance_travelled := it.speed * num_full_cycles * it.time;
        distance_travelled += it.speed * min(remaining_seconds, it.time);
        furthest = max(furthest, distance_travelled);
    }

    return tprint("%", furthest), tprint("%", "");
}

Reindeer :: struct
{
    name: string;
    speed: s64;
    time: s64;
    rest: s64;
}

read_reindeer :: (s: *string) -> Reindeer
{
    result: Reindeer;

    result.name.data = s.data;
    while s.data[0] != #char " "
    {  
        result.name.count += 1;
        advance(s, 1);
    }

    advance(s, 9);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.speed *= 10;
        result.speed += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 10);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.time *= 10;
        result.time += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 33);

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result.rest *= 10;
        result.rest += s.data[0] - #char "0";
        advance(s, 1);
    }

    advance(s, 10);

    return result;
}