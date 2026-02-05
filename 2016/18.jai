day18 :: (data: string) -> string, string
{
    do_steps :: (s: string, n: int) -> int
    {
        buffer : [2][..]u8;
        array_add(*buffer[0], 1); array_add(*buffer[1], 1);
        for 0..s.count-2 {
            array_add(*buffer[0], xx ifx s[it] == #char "^" then 0 else 1);
            array_add(*buffer[1], xx ifx s[it] == #char "^" then 0 else 1);
        }
        array_add(*buffer[0], 1); array_add(*buffer[1], 1);

        bi := 0;
        safe := 0;

        for 1..n
        {
            prev := buffer[bi];
            next := buffer[1-bi];

            for ni: 1..next.count-2
            {
                safe += next[ni];
                next[ni] = xx (prev[ni-1] == prev[ni+1]);
            }

            bi = 1 - bi;
        }

        return safe;
    }

    part_1 := do_steps(data, 40);
    part_2 := do_steps(data, 400000);

    return tprint("%", part_1), tprint("%", part_2);
}