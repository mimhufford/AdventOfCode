day6 :: (input: string) -> string, string
{
    races : [..]Race;

    advance_then_skip_whitespace(*input, 9); // skip "Time: "
    while is_digit(input[0])
    {
        race := array_add(*races);
        race.time = read_s64(*input);
    }

    advance_then_skip_whitespace(*input, 9); // skip "Distance: "
    for * races it.distance = read_s64(*input);

    for * r: races
    {
        for 0..r.time
        {
            speed := it;
            time_left := r.time - it;
            distance := speed * time_left;
            if distance > r.distance r.ways_to_win += 1;
        }
    }

    part1 := 1;
    for races part1 *= it.ways_to_win;
    
    return tprint("%", part1), tprint("%", 0);
}

#scope_file

Race :: struct
{
    time, distance : s64;
    ways_to_win : s64;
}