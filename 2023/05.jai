day5 :: (input: string) -> string, string
{
    seeds1, seeds2 : [..]Range;
    mappings : [..][..]Mapping;

    advance(*input, 7); // skip "seeds: "
    while is_digit(input[0])
    {
        range1 := array_add(*seeds1);
        range1.start = read_s64(*input);
        range1.end = range1.start;
        range2 := array_add(*seeds2);
        range2.start = range1.start;
        range2.end = range2.start + read_s64(*input) - 1;
    }
    
    while input.count
    {
        skip_to_next_line(*input);
        mapping := array_add(*mappings);
        while input.count && is_digit(input[0]) array_add(mapping, read_mapping(*input));
    }

    part1 := lowest_location_for_seed_ranges(seeds1, mappings);
    part2 := lowest_location_for_seed_ranges(seeds2, mappings);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

lowest_location_for_seed_ranges :: (seeds: []Range, mappings: [][..]Mapping) -> s64
{
    result := S64_MAX;
    ranges : []Range = seeds;
    for group: mappings  ranges = process_ranges(ranges, group);
    for range: ranges    result = min(result, range.start);
    return result;
}

process_ranges :: (ranges: []Range, group: []Mapping) -> []Range
{
    new_ranges  : [..]Range;
    ranges_left : [..]Range;

    array_add(*ranges_left, ..ranges);

    while ranges_left
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

        if !remapped array_add(*new_ranges, r);
    } 

    return new_ranges;
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
    dest := read_s64(s);
    m : Mapping;
    m.start  = read_s64(s);
    m.end    = m.range.start + read_s64(s);
    m.offset = dest - m.range.start;
    return m;
}