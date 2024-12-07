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

        part1 += ifx check(total, numbers, false) total;
        part2 += ifx check(total, numbers, true)  total;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check :: (target: s64, nums: []s64, $third_op: bool) -> bool
{
    if nums.count == 1 return target == nums[0];

    next := []s64.{ nums.count - 1, nums.data };
    n := nums[nums.count-1];

    if third_op        && unconcat(target, n, next)         return true;
    if target % n == 0 && check(target / n, next, third_op) return true;
    if target >= n     && check(target - n, next, third_op) return true;
    return false;
}

unconcat :: (target: s64, num: s64, nums: []s64) -> bool
{
    length, n := 0.0, num;
    while n { n /= 10; length += 1; }
    divisor := cast(s64)pow(10, length);
    if target % divisor != num return false;
    return check(target / divisor, nums, true);
}