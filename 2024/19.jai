day19 :: (input: string) -> string, string
{
    patterns := parse_patterns(*input);

    part1, part2 := 0;

    while input
    {
        design := read_word(*input);
    }
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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