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

blink :: (s: u64, iterations: u64) -> s64
{
    if iterations == 0 return 1;

    key := s << 7 | iterations;
    cached_result := table_find_pointer(*cache, key);
    if cached_result return cached_result.*;

    result :: (r: s64) -> s64 #expand { table_add(*cache, key, r); return r; }

    // Rule 1
    if s == 0 return result(blink(1, iterations - 1));

    // Rule 2
    did_split, a, b := attempt_split(s);
    if did_split return result(blink(a, iterations - 1) + blink(b, iterations - 1));

    // Rule 3
    return result(blink(s * 2024, iterations - 1));
}

log10 :: #run log(10.0);

attempt_split :: (n: u64) -> bool, u64, u64
{
    digits := cast(u64)(log(n*1.0) / log10) + 1;
    if digits % 2 return false, 0, 0;
    splitter := cast(u64)pow(10.0, digits*0.5);
    return true, n / splitter, n % splitter;
}