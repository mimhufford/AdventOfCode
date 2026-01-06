day8 :: (input: string) -> string, string
{
    parse_node :: (input: *string) -> s64, s64 {
        sum, value := 0;
        child_count := get(s64, input);
        meta_count  := get(s64, input);
        metadata, child_values : [..]s64;
        for 1..child_count { s, v := parse_node(input); array_add(*child_values, v); sum += s; }
        for 1..meta_count { m := get(s64, input); sum += m; array_add(*metadata, m); }
        if !child_count { value = sum; return sum, value; }
        for metadata if it <= child_count value += child_values[it-1];
        return sum, value;
    }

    part1, part2 := parse_node(*input);

    return tprint("%", part1), tprint("%", part2);
}