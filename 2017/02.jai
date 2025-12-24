day2 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for line: split(trim(input), "\n") {
        nums : [..]s64;
        lo, hi := S64_MAX, S64_MIN;

        while line {
            val := read_u16(*line);
            lo = min(lo, val);
            hi = max(hi, val);
            array_add(*nums, val);
        }

        for a: 0..nums.count-1 for b: a+1..nums.count-1 {
            if nums[a] % nums[b] == 0 { part2 += nums[a] / nums[b]; break a; }
            if nums[b] % nums[a] == 0 { part2 += nums[b] / nums[a]; break a; }
        }

        part1 += hi - lo;
    }

    return tprint("%", part1), tprint("%", part2);
}