day9 :: (input: string) -> string, string
{
    part1, part2 := 0;

    test := input;
    test.count -= 1;

    l, r := 0, test.count-1;
    print("'%' '%'\n", l, r);

    while true
    {
        // file
        {
            id := l / 2;
            blocks := test[l] - #char "0";
        }

        l += 1;
        if l >= test.count-1 break;

        // gap
        {
            free_blocks := test[l] - #char "0";
        }

        l += 1;
    }


    return tprint("%", part1), tprint("%", part2);
}