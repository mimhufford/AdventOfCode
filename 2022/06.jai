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

    return tprint("%", index), tprint("%", "");
}