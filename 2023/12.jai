day12 :: (input: string) -> string, string
{
    springs := split(trim(input), "\n");

    part1, part2 := 0;
    for springs
    {
        conditions, amounts := read_spring_data(it);
        part1 += count_combos(conditions, amounts);
        conditions_x5 := tprint("%?%?%?%?%", conditions, conditions, conditions, conditions, conditions);
        amounts_x5 : [..]s64;  for 0..4 for amounts array_add(*amounts_x5, it);
        part2 += count_combos(conditions_x5, amounts_x5);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

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

    if conditions[0] == #char "?"
    {
        // carry on the run
        a := count_combos(advance(conditions), to_match, curr_run+1);

        // end the run
        if !curr_run return a + count_combos(advance(conditions), to_match, 0);
        if curr_run && !to_match || curr_run != to_match[0] return a;
        left_to_match := to_match;
        left_to_match.data += 1;
        left_to_match.count -= 1;
        return a + count_combos(advance(conditions), left_to_match, 0);
    }
    else if conditions[0] == #char "#"
    {
        // carry on the run
        if !to_match return 0;
        if curr_run > to_match[0] return 0;
        return count_combos(advance(conditions), to_match, curr_run+1);
    }
    else // "."
    {
        // end the run
        if !curr_run return count_combos(advance(conditions), to_match, 0);
        if curr_run && !to_match || curr_run != to_match[0] return 0;
        left_to_match := to_match;
        left_to_match.data += 1;
        left_to_match.count -= 1;
        return count_combos(advance(conditions), left_to_match, 0);
    }
}

read_spring_data :: (s: string) -> string, []s64
{
    data := split(s, " ");
    conditions, amount_data := data[0], data[1];
    amounts : [..]s64;
    for split(amount_data, ",") array_add(*amounts, read_s64(*it));
    return conditions, amounts;
}