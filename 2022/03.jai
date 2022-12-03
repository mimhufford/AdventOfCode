day3 :: (input: string) -> string, string
{
    priority_sum := 0;

    while input.count
    {
        line := read_word(*input);
        one := line;  one.count /= 2;
        two := line;  two.count /= 2; two.data += two.count;
        
        for i: 0..one.count-1
        {
            for j: 0..two.count-1
            {
                if one[i] == two[j]
                {
                    if one[i] <= #char "Z" priority_sum += one[i] - 38;
                    else                   priority_sum += one[i] - 96;
                    break i;
                }
            }
        }
    }

    return tprint("%", priority_sum), tprint("%", "");
}