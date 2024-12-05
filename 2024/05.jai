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

        part1, part2 += get_middle_values(update);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

rules : [100][100]bool;

get_middle_values :: (update: []s64) -> s64, s64
{
    for i: 0..update.count-1
    {
        for j: i+1..update.count-1
        {
            if rules[update[j]][update[i]]
            {
                sort :: (a: s64, b: s64) -> s64
                {
                    if rules[a][b] return -1;
                    if rules[b][a] return 1;
                    return 0;
                }

                quick_sort(update, sort);
                return 0, update[update.count / 2];
            }
        }
    }

    return update[update.count / 2], 0;
}