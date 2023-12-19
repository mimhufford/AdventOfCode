day12 :: (input: string) -> string, string
{
    springs := split(trim(input), "\n");

    part1, part2 := 0;
    for springs
    {
        table_reset(*cache);
        part1 += count_combos_for_spring_data(it, 1);
        part2 += count_combos_for_spring_data(it, 5);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

cache : Table(s32, s64);

count_combos :: (conditions: string, to_match: []s64, curr_run := 0) -> s64
{
    if !conditions
    {
        if to_match.count >= 2              return 0;
        if to_match.count == 0 &&  curr_run return 0;
        if to_match.count == 0 && !curr_run return 1;
        if curr_run == to_match[0]          return 1;
                                            return 0;
    }

    end_the_current_run :: () -> s64 #expand
    {
        if !curr_run return count_combos(advance(conditions), to_match, 0);
        if curr_run && !to_match || curr_run != to_match[0] return 0;
        left_to_match := to_match;
        left_to_match.data += 1;
        left_to_match.count -= 1;
        return count_combos(advance(conditions), left_to_match, 0);
    }

    continue_the_current_run :: () -> s64 #expand
    {
        return count_combos(advance(conditions), to_match, curr_run+1);
    }

    if conditions[0] == #char "."
    {
        return end_the_current_run();
    }
    else if conditions[0] == #char "#"
    {
        return continue_the_current_run();
    }
    else                              
    {
        hash := cast(s32)(conditions.count << 20 + curr_run << 10 + to_match.count);
        cached := table_find_pointer(*cache, hash);
        if cached return cached.*;
        result := continue_the_current_run() + end_the_current_run();
        table_add(*cache, hash, result);
        return result;
    }
}

count_combos_for_spring_data :: (s: string, copies: s64) -> s64
{
    data := split(s, " ");
    condition_data, amount_data := data[0], data[1];
    conditions : String_Builder;
    amounts : [..]s64;
    for 1..copies
    {
        append(*conditions, ifx it < copies tprint("%?", condition_data) else condition_data);
        for split(amount_data, ",") array_add(*amounts, read_s64(*it));
    }
    return count_combos(builder_to_string(*conditions), amounts);
}