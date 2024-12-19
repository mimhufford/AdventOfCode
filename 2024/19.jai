day19 :: (input: string) -> string, string
{
    patterns := parse_patterns(*input);

    part1, part2 := 0;

    while input
    {
        design := read_word(*input);
        part1 += ifx is_possible(design, patterns) 1;
    }
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

is_possible :: (design: string, patterns: []string) -> bool
{
    if design.count == 0 return true;

    for pattern: patterns
    {
        if starts_with(design, pattern)
        {
            return is_possible(advance(design, pattern.count), patterns);
        }
    }

    return false;
}

// 167 too low

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