day2 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        numbers : [..]s64;

        while input[0] != #char "\n"
        {
            skip_whitespace(*input);
            array_add(*numbers, read_number(s64, *input, skip_trailing_whitespace = false));
        }

        if check(numbers)      part1, part2 += 1;
        else if check_combos(numbers) part2 += 1;

        skip_whitespace(*input);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check_combos :: (nums: []s64) -> bool
{
    for 0..nums.count-1
    {
        new_nums := array_copy(nums);
        array_ordered_remove_by_index(*new_nums, it);
        if check(new_nums) return true;
    }

    return false;
}

check :: (nums: []s64) -> bool
{
    asc, desc := true;

    for 0..nums.count-2
    {
        a, b := nums[it], nums[it+1];

        if abs(a - b) > 3 return false;
        if b >= a  desc = false;
        if b <= a   asc = false;
        if !asc && !desc  return false;
    }

    return true;
}