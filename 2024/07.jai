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

        part1 += ifx check(total, .{numbers.count-1, numbers.data+1}, numbers[0], false) total;
        part2 += ifx check(total, .{numbers.count-1, numbers.data+1}, numbers[0], true)  total;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check :: (target: s64, nums: []s64, accum: s64, $third_op: bool) -> bool
{
    if nums.count == 0 return accum == target;
    if accum > target return false;

    next := []s64.{ nums.count - 1, nums.data + 1};
    return check(target, next, accum + nums[0], third_op) ||
           check(target, next, accum * nums[0], third_op) ||
           ifx third_op check(target, next, concat(accum, nums[0]), third_op);
}

concat :: (a: s64, b: s64) -> s64
{
    multiplier := 1;
    while b >= multiplier multiplier *= 10;
    return a * multiplier + b;
}