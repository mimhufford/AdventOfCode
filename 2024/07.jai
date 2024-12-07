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
        cat := number_ends_with(target, n);
        if cat
        {
            tar := tprint("%", target);
            tar.count -= tprint("%", n).count;
            nwt := read_s64(*tar);
            if check3(nwt, next, third_op) return true;
        }
    }

    if target % n == 0 && check3(target / n, next, third_op) return true;

    return check3(target - n, next, third_op);
}

number_ends_with :: (n: s64, suffix: s64) -> bool
{
    length, s := 0.0, suffix;
    while s { s /= 10; length += 1; }
    return n % cast(s64)pow(10, length) == suffix;
}