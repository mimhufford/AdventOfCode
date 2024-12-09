day9 :: (input: string) -> string, string
{
    part1, part2 := 0;

    test := input;
    test.count -= 1;

    position, l, r := 0, 0, test.count-1;

    while true
    {
        // file
        {
            id := l / 2;
            blocks := test[l] - #char "0";

            // add checksum for file
            for 1..blocks
            {
                part1 += id * position;
                position += 1;
            }
        }

        // move left pointer
        l += 1;
        if l >= test.count-1 break;

        // fill the gap
        free_blocks := test[l] - #char "0";
        while free_blocks > 0 && r > l
        {
            id := r / 2;
            blocks := test[r] - #char "0";

            if blocks > 0
            {
                test[r] -= 1;
                part1 += id * position;
                position += 1;
                free_blocks -= 1;
            }
            else
            {
                r -= 2;
            }
        }

        l += 1;
    }

    return tprint("%", part1), tprint("%", part2);
}