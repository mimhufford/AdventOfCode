day5 :: (input: string) -> string, string
{
    part1, part2 := S64_MAX, S64_MAX;

    seeds : [..]s64;
    seed_ranges : [..]Range;
    mappings : [..][..]Mapping;

    advance_then_skip_whitespace(*input, 7); // skip "seeds: "
    while is_digit(input[0])
    {
        range := array_add(*seed_ranges);
        range.start = read_s64(*input);
        range.end = range.start + read_s64(*input) - 1;
        array_add(*seeds, range.start);
        array_add(*seeds, range.end - range.start + 1);
    }
    
    while input.count
    {
        skip_to_next_line(*input);
        mapping := array_add(*mappings);
        while input.count && is_digit(input[0]) array_add(mapping, read_mapping(*input));
    }

    for seed: seeds
    {
        part1 = min(part1, map_seed_to_location(seed, mappings));
    }

    ranges : []Range = seed_ranges;
    for group: mappings  ranges = map_range_to_ranges(ranges, group);
    for range: ranges    part2 = min(part2, range.start);

    return tprint("%", part1), tprint("%", part2);
}

map_range_to_ranges :: (ranges: []Range, group: []Mapping) -> []Range
{
    new_ranges  : [..]Range;
    ranges_left : [..]Range;

    array_add(*ranges_left, ..ranges);

    while ranges_left.count
    {
        r := pop(*ranges_left);

        remapped := false;
        for mapping: group
        {
            if mapping.start > r.end   continue;
            if mapping.end   < r.start continue;

            remapped = true;
            new_range := array_add(*new_ranges);
            new_range.start = max(r.start, mapping.start) + mapping.offset;
            new_range.end   = min(r.end,   mapping.end)   + mapping.offset;

            if mapping.start > r.start
            {
                before := array_add(*ranges_left);
                before.start = r.start;
                before.end = mapping.start-1;
            }

            if mapping.end < r.end
            {
                after := array_add(*ranges_left);
                after.start = mapping.end+1;
                after.end = r.end;
            }
        }

        if !remapped
        {
            array_add(*new_ranges, r);
        }
    } 

    return new_ranges;
}

map_seed_to_location :: (seed: s64, mappings: [][..]Mapping) -> s64
{
    value := seed;

    for group: mappings
    {
        for mapping: group
        {
            if value <= mapping.end && value >= mapping.start
            {
                value += mapping.offset;
                break mapping;
            }
        }
    }

    return value;
}

Range :: struct
{
    start, end : s64;
}

Mapping :: struct
{
    using range : Range;
    offset : s64;
}

read_mapping :: (s: *string) -> Mapping
{
    m : Mapping;
    dest := read_s64(s);
    m.range.start = read_s64(s);
    m.range.end   = m.range.start + read_s64(s);
    m.offset      = dest - m.range.start;
    return m;
}