day6 :: (input: string) -> string, string
{
    return tprint("%", solve_for_window_size(4, input)), tprint("%", solve_for_window_size(14, input));
}

solve_for_window_size :: (n: int, input: string) -> int
{
    window := input;
    window.count = n;

    while true
    {
        repeat := false;

        for i: 0..n-1
        {
            for j: i+1..n-1
            {
                if window[i] != window[j] continue;

                window.data += 1;
                repeat = true;
                break i;
            }
        }

        if !repeat return window.data - input.data + n;
    }
}