day6 :: (input: string) -> string, string
{
    index := 4;
    window := input;
    window.count = 4;

    while true
    {
        if window[0] == window[1] || window[0] == window[2] || window[0] == window[3] ||
           window[1] == window[2] || window[1] == window[3] || window[2] == window[3]
        {
            window.data += 1;
            index += 1;
        }
        else
        {
            break;
        }
    }

    msg := 14;
    w14 := input;
    w14.count = 14;

    while true
    {
        found := false;

        for i: 0..13
        {
            for j: i+1..13
            {
                if w14[i] == w14[j]
                {
                    w14.data += 1;
                    msg += 1;
                    found = true;
                    break i;
                }
            }
        }

        if !found
        {
            break;
        }
    }

    return tprint("%", index), tprint("%", msg);
}