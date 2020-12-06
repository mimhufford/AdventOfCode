day6 :: () -> string, string
{
    data := input(6);

    part1, part2 := 0;

    for i: 0..data.count-1
    {
        all_answered := 0xFFFF_FFFF_FFFF_FFFF;
        any_answered := 0x0000_0000_0000_0000;

        while true // handle one group
        {
            one_answered := 0;

            while i < data.count && data[i] != #char "\n" // handle one person
            {
                bit := 1 << (data[i] - #char "a");
                any_answered |= bit;
                one_answered |= bit;
                i += 1;
            }

            all_answered &= one_answered;

            if i == data.count break;
            if data[i] == #char "\n" && data[i+1] == #char "\n" { i += 1; break; }

            i += 1;
        }

        part1 += bit_count(any_answered);
        part2 += bit_count(all_answered);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

bit_count :: (i: int) -> int
{
    count := 0;
    for 0..63 if i & (1<<it) count += 1;
    return count;
}