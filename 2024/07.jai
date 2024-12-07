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

        if check_2_ops(total, .{numbers.count-1, numbers.data+1}, numbers[0]) part1 += total;
        if check_3_ops(total, .{numbers.count-1, numbers.data+1}, numbers[0]) part2 += total;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

check_2_ops :: (target: s64, nums: []s64, accum: s64) -> bool
{
    if nums.count == 0 && accum == target return true;
    if nums.count == 0 return false;
    if accum > target return false;

    return check_2_ops(target, .{nums.count-1, nums.data+1}, accum + nums[0]) ||
           check_2_ops(target, .{nums.count-1, nums.data+1}, accum * nums[0]);

}

check_3_ops :: (target: s64, nums: []s64, accum: s64) -> bool
{
    if nums.count == 0 && accum == target return true;
    if nums.count == 0 return false;
    if accum > target return false;

    return check_3_ops(target, .{nums.count-1, nums.data+1}, accum + nums[0]) ||
           check_3_ops(target, .{nums.count-1, nums.data+1}, accum * nums[0]) ||
           check_3_ops(target, .{nums.count-1, nums.data+1}, concat(accum, nums[0]));

}

concat :: (a: s64, b: s64) -> s64
{
    multiplier := 1;
    while b >= multiplier multiplier *= 10;
    return a * multiplier + b;
}