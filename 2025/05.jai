day5 :: (input: string) -> string, string
{
    part1, part2 : s64;

    ranges : [..] struct { lo, hi: u64; };

    while input {
        range := array_add(*ranges);
        range.lo = read_number(u64, *input); advance(*input);
        range.hi = read_number(u64, *input, skip_trailing_whitespace = false);
        advance(*input);
        if input[0] == "\n" { advance(*input); break; }
    }

    while input {
        id := read_u64(*input);
        for ranges {
            if id >= it.lo && id <= it.hi {
                part1 += 1;
                break;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}