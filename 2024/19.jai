day19 :: (input: string) -> string, string
{
    part1, part2 := 0;
    parse_patterns(*input);

    while input
    {
        design := read_word(*input);
        table_reset(*cache);
        combos := count_combos(design);
        part1 += ifx combos then 1;
        part2 += combos;
    }
    
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

nodes : [..]Node;

Node :: struct
{
    next : [26]s64;
    end := false;
}

cache : Table(s64, s64);

count_combos :: (design: string, node_index := 0) -> s64
{
    key := design.count << 32 | node_index;
    cached_result := table_find_pointer(*cache, key);
    if cached_result return cached_result.*;

    node := *nodes[node_index];

    if !design.count return ifx node.end then 1;

    c := design[0] - #char "a";

    combos := 0;

    if node.next[c] combos += count_combos(advance(design), node.next[c]);
    if node.end     combos += count_combos(design);

    table_add(*cache, key, combos);
    return combos;
}

parse_patterns :: (s: *string)
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

    array_reserve(*nodes, 1000);
    root := array_add(*nodes);
    
    for p: patterns
    {
        node := root;
        for char: p
        {
            c := char - #char "a";
            if node.next[c] == 0
            {
                _ := array_add(*nodes);
                node.next[c] = nodes.count - 1;
            }
            node = *nodes[node.next[c]];
        }
        node.end = true;
    }

    skip_whitespace(s);
}