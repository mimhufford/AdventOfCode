day11 :: (input: string) -> string, string
{
    stones : [..]s64;
    
    while input array_add(*stones, read_s64(*input));

    part1, part2 := 0;
    for stones part1 += blink(it, 25);
    for stones part2 += blink(it, 75);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

blink :: (s: s64, iterations: s64) -> s64
{
    if iterations == 0 return 1;

    // Rule 1
    if s == 0 return blink(1, iterations - 1);

    // Rule 2
    did_split, a, b := attempt_split(s);
    if did_split return blink(a, iterations - 1) + blink(b, iterations - 1);

    // Rule 3
    return blink(s * 2024, iterations - 1);
}

log10 :: #run log(10.0);

attempt_split :: (n: s64) -> bool, s64, s64
{
    digits := cast(s64)(log(n*1.0) / log10) + 1;
    if digits % 2 return false, 0, 0;
    splitter := cast(s64)pow(10.0, digits*0.5);
    return true, n / splitter, n % splitter;
}