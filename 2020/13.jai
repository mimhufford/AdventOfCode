day13 :: (input: string) -> string, string
{
    now      := read_number(*input);
    schedule : [..]u64;

    while input.count array_add(*schedule, read_number(*input));

    part1 := calculate_next_bus(now, schedule);
    part2 := find_sequence(schedule);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

find_sequence :: (schedule: []u64) -> u64
{
    start : u64 = 0;
    skip  : u64 = schedule[0];

    while true
    {
        found := true;
        for schedule
        {
            if (start + cast(u64)it_index) % it == 0 continue;

            skip = schedule[0];
            for i: 1..it_index-1 skip *= schedule[i];
            found = false;
            break;
        }

        if found return start;
        start += skip;
    }

    assert(false);
    return 0;
}

calculate_next_bus :: (start: u64, schedule: []u64) -> u64
{
    best_id    : u64 = 0;
    best_delay : u64 = 999999999;

    for schedule
    {
        if it == 1 continue;
        delay := it - start % it;
        if delay < best_delay
        {
            best_id    = it;
            best_delay = delay;
        }
    }

    return best_id * best_delay;
}

read_number :: (s: *string) -> u64
{
    num : u64;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    if s.count && s.data[0] == #char "x" { num = 1; advance(s, 1); }
    if s.count advance(s, 1);

    return num;
}