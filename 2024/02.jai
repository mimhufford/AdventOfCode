day2 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        numbers : [..]s64;

        while input && input[0] != #char "\n"
        {
            skip_whitespace(*input);
            array_add(*numbers, read_number(s64, *input, skip_trailing_whitespace = false));
        }

        part1 += check(numbers);

        for 0..numbers.count-1
        {
            new_numbers := array_copy(numbers);
            array_ordered_remove_by_index(*new_numbers, it);
            if check(new_numbers)
            {
                part2 += 1;
                break;
            }
        }

        skip_whitespace(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check :: (nums: []s64) -> s64
{
    asc, desc := true;

    for 0..nums.count-2
    {
        a, b := nums[it], nums[it+1];

        if abs(a - b) > 3 return 0;
        if b >= a  desc = false;
        if b <= a   asc = false;
        if asc == false && desc == false return 0;
    }

    return 1;
}