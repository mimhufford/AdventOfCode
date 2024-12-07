day7 :: (input: string) -> string, string
{
    numbers : [..]s64;
    part1, part2 := 0;

    while input
    {
        array_reset_keeping_memory(*numbers);
        total := read_s64(*input);
        advance(*input, 2);
        while true
        {
            array_add(*numbers, read_number(s64, *input, skip_trailing_whitespace = false));
            defer advance(*input);
            if input[0] == #char "\n" break;
        }

        part1 += ifx check3(total, numbers, false) total;
        part2 += ifx check3(total, numbers, true)  total;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check3 :: (target: s64, nums: []s64, third_op: bool) -> bool
{
    if nums.count == 1 return target == nums[0];

    next := []s64.{ nums.count - 1, nums.data };
    n := nums[nums.count-1];

    if third_op
    {
        cat := ends_with(tprint("%", target), tprint("%", n));
        tar := tprint("%", target);
        tar.count -= tprint("%", n).count;
        nwt := ifx cat then read_s64(*tar) else target;
        if cat && check3(nwt, next, third_op) return true;
    }

    mul := target % n == 0;
    if mul && check3(target / n, next, third_op) return true;

    return check3(target - n, next, third_op);
}