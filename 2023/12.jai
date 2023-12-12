day12 :: (input: string) -> string, string
{
    springs := split(trim(input), "\n");

    part1 := 0;
    for springs
    {
        conditions, amounts := read_spring_data(it);
        part1 += count_combos(conditions, amounts);
    }

    return tprint("%", part1), tprint("%", 0);
}

#scope_file

count_combos :: (conditions: string, amounts: []s64) -> s64
{
    for i: 0..conditions.count-1
    {
        if conditions[i] == #char "?"
        {
            c1 := copy_string(conditions); c1[i] = #char "#";
            c2 := copy_string(conditions); c2[i] = #char ".";

            return count_combos(c1, amounts) + count_combos(c2, amounts);
        }
    }

    amount_i := 0;
    i := 0;
    while i < conditions.count
    {
        amount := 0;

        while i < conditions.count && conditions[i] == #char "#"
        {
            amount += 1;
            i += 1;
        }

        i += 1;

        if amount
        {
            if amount_i >= amounts.count   return 0;
            if amount != amounts[amount_i] return 0;
            amount_i += 1;
        }
    }

    return xx(amount_i == amounts.count);
}

read_spring_data :: (s: string) -> string, []s64
{
    data := split(s, " ");
    conditions, amount_data := data[0], data[1];
    amounts : [..]s64;
    for split(amount_data, ",") array_add(*amounts, read_s64(*it));
    return conditions, amounts;
}