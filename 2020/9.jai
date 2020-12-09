day9 :: (input: string) -> string, string
{
    for numbers numbers[it_index] = read_number(*input);
    part1 := find_no_sum_number();
    part2 := find_consequtive_sum(part1);
    return tprint("%", part1), tprint("%", part2);
}

#scope_file

numbers : [1000]u64;

find_consequtive_sum :: (goal: u64) -> u64
{
    for i: 0..999
    {
        total : u64;

        for j: i..999
        {
            total += numbers[j];

            if total == goal return sum_of_min_and_max(i, j);
            if total > goal break;
        }
    }

    assert(false);
    return 0;
}

sum_of_min_and_max :: (i: s64, j: s64) -> u64
{
    min : u64 = 0xFFFF_FFFF_FFFF_FFFF;
    max : u64 = 0x0000_0000_0000_0000;

    for i..j
    {
        if numbers[it] < min min = numbers[it];
        if numbers[it] > max max = numbers[it];
    }

    return min + max;
}

find_no_sum_number :: () -> u64
{
    for 25..999
    {
        next := numbers[it];
        match := false;

        for i: it-25..it-1
        {
            if match break;
            for j: i+1..it-1
            {
                if numbers[i] + numbers[j] == next
                {
                    match = true;
                    break;
                } 
            }
        }

        if !match return next;
    }

    assert(false);
    return 0;
}

read_number :: (s: *string) -> u64
{
    result: u64;

    while s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        result *= 10;
        result += s.data[0] - #char "0";
        advance(s, 1);
    }

    if s.count advance(s, 1);

    return result;
}