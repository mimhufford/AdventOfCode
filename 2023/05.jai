day5 :: (input: string) -> string, string
{
    part1, part2 := S64_MAX, 0;

    seeds : [..]s64;
    mappings : [..][..]Range_Map;

    advance_then_skip_whitespace(*input, 7); // skip "seeds: "
    while is_digit(input[0]) array_add(*seeds, read_s64(*input));
    
    while input.count
    {
        skip_to_next_line(*input);
        mapping := array_add(*mappings);
        while input.count && is_digit(input[0]) array_add(mapping, read_range_map(*input));
    }

    for seed: seeds
    {
        value := seed;

        for mapping: mappings
        {
            for range: mapping
            {
                if value <= range.source_start + range.length && value >= range.source_start
                {
                    value -= range.source_start - range.dest_start;
                    break range;
                }
            }
        }

        part1 = min(part1, value);
    }

    return tprint("%", part1), tprint("%", part2);
}

Range_Map :: struct
{
    dest_start, source_start, length : s64;
}

read_range_map :: (s: *string) -> Range_Map
{
    rp : Range_Map;
    rp.dest_start = read_s64(s);
    rp.source_start = read_s64(s);
    rp.length = read_s64(s);
    return rp;
}