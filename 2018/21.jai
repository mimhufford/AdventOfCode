day21 :: (input: string) -> string, string
{
    lines := split(input, "\n");
    read_word(*lines[8]);
    seed := read_s64(*lines[8]);
    part1, part2 := 0;
    b, c, last := 0, 0, S64_MAX;
    seen : Table(s64, u8);

    while true {
        _, new := find_or_add(*seen, c);
        if !last { part1 = c; }
        if !new  { part2 = last; break; }
        b, last, c = c | 65536, c, seed;
        while b {
            c = (((c + (b % (1<<8))) % (1<<24)) * 65899) % (1<<24);
            b >>= 8;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}