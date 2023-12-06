day6 :: (input: string) -> string, string
{
    races : [..]Race;
    actual_race : Race;
    time, dist : String_Builder;

    advance_then_skip_whitespace(*input, 9); // skip "Time: "
    while is_digit(input[0])
    {
        race := array_add(*races);
        race.time = read_s64(*input);
        append(*time, tprint("%", race.time));
    }

    advance_then_skip_whitespace(*input, 9); // skip "Distance: "
    for * race: races
    {
        race.dist = read_s64(*input);
        append(*dist, tprint("%", race.dist));
    }

    part1 := 1;
    for races part1 *= calculate_ways_to_win(it);

    actual_race.time = string_to_int(builder_to_string(*time));
    actual_race.dist = string_to_int(builder_to_string(*dist));
    part2 := calculate_ways_to_win(actual_race);
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

calculate_ways_to_win :: (r: Race) -> s64
{
    for 0..r.time
    {
        dist := it * (r.time - it);
        if dist > r.dist return r.time - it - it + 1;
    }

    return 0;
}

Race :: struct
{
    time, dist : s64;
}