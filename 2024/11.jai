day11 :: (input: string) -> string, string
{
    stones : [..]u64;
    
    while input array_add(*stones, read_u64(*input));

    part1, part2 := 0;
    for stones part1 += blink(it, 25);
    for stones part2 += blink(it, 75);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

cache : Table(u64, s64);

pack_key :: (s: u64, iterations: u64) -> u64
{
    key := s;
    key <<= 7;
    key |= iterations;
    return key;
}

blink :: (s: u64, iterations: u64) -> s64
{
    if iterations == 0 return 1;

    key := pack_key(s, iterations);
    cached_result := table_find_pointer(*cache, key);
    if cached_result return cached_result.*;

    // Rule 1
    if s == 0
    {
        result := blink(1, iterations - 1);
        table_add(*cache, key, result);
        return result;
    }

    // Rule 2
    did_split, a, b := attempt_split(s);
    if did_split
    {
        result := blink(a, iterations - 1) + blink(b, iterations - 1);
        table_add(*cache, key, result);
        return result;
    }

    // Rule 3
    {
        result := blink(s * 2024, iterations - 1);
        table_add(*cache, key, result);
        return result;
    }
}

log10 :: #run log(10.0);

attempt_split :: (n: u64) -> bool, u64, u64
{
    digits := cast(u64)(log(n*1.0) / log10) + 1;
    if digits % 2 return false, 0, 0;
    splitter := cast(u64)pow(10.0, digits*0.5);
    return true, n / splitter, n % splitter;
}