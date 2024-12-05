day5 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while true
    {
        a := read_number(s64, *input, skip_trailing_whitespace = false); advance(*input);
        b := read_number(s64, *input, skip_trailing_whitespace = false); advance(*input);
        rules[a][b] = true;
        if input[0] == #char "\n" break;
    }

    update : [..]s64;

    while input
    {
        array_reset_keeping_memory(*update);

        while true
        {
            n := read_number(s64, *input, skip_trailing_whitespace = false);
            array_add(*update, n);
            if input[0] == #char "," then advance(*input);
            else { skip_whitespace(*input); break; }
        }

        part1 += middle_value_or_0_if_sorted(update);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

rules : [100][100]bool;

middle_value_or_0_if_sorted :: (update: []s64) -> s64
{
    for i: 0..update.count-1
    {
        for j: i+1..update.count-1
        {
            if rules[update[j]][update[i]] return 0;
        }
    }

    return update[update.count / 2];
}