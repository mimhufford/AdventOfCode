day7 :: (data : string) -> string, string
{
    nums : [..]s16;
    total : s64;

    while data.count
    {
        num := get(s16, *data);
        array_add(*nums, num);
        total += num;
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