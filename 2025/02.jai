day2 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        lo := read_s64(*input);
        advance(*input);
        hi := read_s64(*input);
        if input advance(*input);
    
        for n: lo..hi {
            // TODO: use maths
            str := tprint("%", n);

            for div: 2..str.count {
                if str.count % div continue;
                a := str;
                a.count /= div;

                for part: 2..div {
                    b := a;
                    b.data += b.count * (part - 1);
                    if a != b continue div;
                }

                if div == 2 then part1 += n;
                part2 += n;
                break;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}