day7 :: (data : string) -> string, string
{
    nums : [..]s16;
    total : s64;

    while data.count
    {
        num : s16;
        while data.count && data[0] >= #char "0" && data[0] <= #char "9"
        {
            num *= 10;
            num += data[0] - #char "0";
            advance(*data, 1);
        }
        array_add(*nums, num);
        total += num;
        advance(*data, 1);
    }

    quick_sort(nums, (a, b) => a - b);

    part1 : s64;
    median := (nums[(nums.count-1)/2] + nums[nums.count/2]) / 2;
    for nums  part1 += abs(it - median);

    part2 : s64;
    mean := (total / nums.count);
    for nums  part2 += abs(it - mean) * (abs(it - mean) + 1) / 2; // gauss in tha hauss

    return tprint("%", part1), tprint("%", part2);
}