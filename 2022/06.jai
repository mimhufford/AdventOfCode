day6 :: (input: string) -> string, string
{
    return tprint("%", solve_for_window_size(4, input)), tprint("%", solve_for_window_size(14, input));

    solve_for_window_size :: (n: int, input: string) -> int
    {
        for i: 0..input.count
        {
            repeat := false;

            for a: i..i+n-1
            {
                for b: a+1..i+n-1
                {
                    if input[a] != input[b] continue;

                    repeat = true;
                    break a;
                }
            }

            if !repeat return i + n;
        }

        return 0;
    }
}