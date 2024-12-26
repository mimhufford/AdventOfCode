day11 :: (input: string) -> string, string
{
    stones : [..]u64;
    
    while input array_add(*stones, read_u64(*input));

    init(*cache, 150_000);
    part1, part2 := 0;
    for stones part1 += blink(it, 25);
    for stones part2 += blink(it, 75);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

cache : Table(u64, s64);

blink :: (stone: u64, blinks_left: u64) -> s64
{
    if blinks_left == 0 return 1;

    key := stone << 7 | blinks_left;
    cached_result := table_find_pointer(*cache, key);
    if cached_result return cached_result.*;

    result :: (r: s64) -> s64 #expand { table_add(*cache, key, r); return r; }

    // Rule 1
    if stone == 0 return result(blink(1, blinks_left - 1));

    // Rule 2
    did_split, a, b := attempt_split(stone);
    if did_split return result(blink(a, blinks_left - 1) + blink(b, blinks_left - 1));

    // Rule 3
    return result(blink(stone * 2024, blinks_left - 1));
}

attempt_split :: (n: u64) -> bool, u64, u64
{
    pow10 :: u64.[1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000];
    digit_count, current := 0, n;
    while current { digit_count += 1; current /= 10; }
    if digit_count % 2 return false, 0, 0;
    splitter := pow10[digit_count/2];
    return true, n / splitter, n % splitter;
}