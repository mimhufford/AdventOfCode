day6 :: (input: string) -> string, string
{
    return tprint("%", solve_for_window_size(4, input)), tprint("%", solve_for_window_size(14, input));
}

solve_for_window_size :: (n: int, data: string) -> int
{
    window := data;
    window.count = n;
    index := n;

    while true
    {
        found := false;

        for i: 0..n-1
        {
            for j: i+1..n-1
            {
                if window[i] == window[j]
                {
                    window.data += 1;
                    index += 1;
                    found = true;
                    break i;
                }
            }
        }

        if !found
        {
            return index;
        }
    }
}