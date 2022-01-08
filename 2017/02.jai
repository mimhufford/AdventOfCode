day2 :: (data: string) -> string, string
{
    part_1, part_2 := 0;

    lines := split(data, "\n");
    lines.count -= 1;

    for * line: lines
    {
        lo, hi := S64_MAX, S64_MIN;

        nums : [..]s64;

        while <<line
        {
            val := 0;
            ok := true;
            val, ok, <<line = string_to_int(<<line);
            lo = min(lo, val);
            hi = max(hi, val);
            array_add(*nums, val);
        }

        for a: 0..nums.count-1 for b: a+1..nums.count-1
        {
            if nums[a] % nums[b] == 0 { part_2 += nums[a] / nums[b]; break a; }
            if nums[b] % nums[a] == 0 { part_2 += nums[b] / nums[a]; break a; }
        }

        part_1 += hi - lo;
    }

    return tprint("%", part_1), tprint("%", part_2);
}