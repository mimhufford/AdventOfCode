day6 :: (data: string) -> string, string
{
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

            i += 1;
            if i >= data.count || data[i] == #char "\n" break;
        }

        part1 += popcount(any_answered);
        part2 += popcount(all_answered);
    }

    return tprint("%", part1), tprint("%", part2);
}

#import "Bit_Operations";