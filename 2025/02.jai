day2 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        lo := read_s64(*input);
        advance(*input);
        hi := read_s64(*input);
        if input advance(*input);
    
        for lo..hi {
            // TODO: use maths
            str := tprint("%", it);
            if str.count % 2 continue;
            a, b := str, str;
            a.count /= 2;
            advance(*b, str.count / 2);
            if a == b then part1 += it;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}