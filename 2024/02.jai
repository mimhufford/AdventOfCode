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
        if index_to_skip == -1
        {
            asc, desc := true;
            for 0..nums.count-2
            {
                a, b := nums[it], nums[it+1];

                if abs(a - b) > 3 continue index_to_skip;
                if b >= a  desc = false;
                if b <= a   asc = false;
                if !asc && !desc  continue index_to_skip;
            }

            return 1, 1;
        }
        else
        {
            asc, desc := true;
            for 0..nums.count-3
            {
                ai, bi := it, it + 1;
                if ai >= index_to_skip then ai += 1;
                if bi >= index_to_skip then bi += 1;
                a, b := nums[ai], nums[bi];

                if abs(a - b) > 3 continue index_to_skip;
                if b >= a  desc = false;
                if b <= a   asc = false;
                if !asc && !desc  continue index_to_skip;
            }
            return 0, 1;
        }
    }

    return 0, 0;
}