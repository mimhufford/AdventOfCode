day2 :: (input: string) -> string, string
{
    numbers : [..]s64;
    part1, part2 := 0;

    while input
    {
        while input[0] != #char "\n"
        {
            skip_whitespace(*input);
            array_add(*numbers, read_number(s64, *input, skip_trailing_whitespace = false));
        }

        part1, part2 += check(numbers);

        skip_whitespace(*input);
        array_reset_keeping_memory(*numbers);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check :: (nums: []s64) -> s64, s64
{
    for index_to_skip: -1..nums.count-1
    {
        asc, desc := true;

        for 0..nums.count - 2 - ifx index_to_skip >= 0 then 1
        {
            a_index := it + 0 + ifx index_to_skip >= 0 && it + 0 >= index_to_skip then 1;
            b_index := it + 1 + ifx index_to_skip >= 0 && it + 1 >= index_to_skip then 1;
            a, b := nums[a_index], nums[b_index];

            if abs(a - b) > 3 continue index_to_skip;
            if b >= a  desc = false;
            if b <= a   asc = false;
            if !asc && !desc  continue index_to_skip;
        }

        return ifx index_to_skip == -1 then 1 else 0, 1;
    }

    return 0, 0;
}