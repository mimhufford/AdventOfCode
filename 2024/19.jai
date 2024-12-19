day19 :: (input: string) -> string, string
{
    part1, part2 := 0;
    patterns := parse_patterns(*input);

    while input
    {
        design := read_word(*input);
        combos := count_combos(design, patterns);
        part1 += ifx combos then 1;
        part2 += combos;
    }
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

cache : Table(string, s64);

count_combos :: (design: string, patterns: []string) -> s64
{
    if design.count == 0 return 1;
    cached_result := table_find_pointer(*cache, design);
    if cached_result return cached_result.*;

    combos := 0;

    for pattern: patterns
    {
        if !starts_with(design, pattern) continue;
        combos += count_combos(advance(design, pattern.count), patterns);
    }

    table_add(*cache, design, combos);
    return combos;
}

parse_patterns :: (s: *string) -> []string
{
    patterns : [..]string;

    while true
    {
        pattern := s.*;
        pattern.count = 0;

        while s.*[0] != #char "," && s.*[0] != #char "\n"
        {
            advance(s);
            pattern.count += 1;
        }

        array_add(*patterns, pattern);

        if s.*[0] == #char "\n" break;
        advance(s, 2);
    }

    skip_whitespace(s);
    return patterns;
}