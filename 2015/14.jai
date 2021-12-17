day14 :: (data: string) -> string, string
{
    reindeers : [..]Reindeer;

    while data.count array_add(*reindeers, read_reindeer(*data));

    for s: 0..2503
    {
        for * reindeers
        {
            full_cycle := it.time + it.rest;
            it.distance = it.speed * (s / full_cycle * it.time + min(s % full_cycle, it.time));
        }

        furthest := 0; for reindeers furthest = max(furthest, it.distance);
        for * reindeers if it.distance == furthest it.score += 1;
    }

    furthest := 0; for reindeers  furthest = max(furthest, it.distance);
    hi_score := 0; for reindeers  hi_score = max(hi_score, it.score-1);
    
    return tprint("%", furthest), tprint("%", hi_score);
}

Reindeer :: struct
{
    speed: s64;
    time: s64;
    rest: s64;
    distance: s64;
    score: s64;
}

read_reindeer :: (s: *string) -> Reindeer
{
    result: Reindeer;

    while s.data[0] != #char " " advance(s, 1);

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