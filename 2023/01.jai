day1 :: (input: string) -> string, string
{
    part1 := 0;

    while input.count
    {
        first, last := -1, -1;

        while input.count
        {   
            if is_whitespace(input[0])
            {
                advance(*input);
                break;
            } 

            if is_digit(input[0])
            {
                last = input[0] - #char "0";
                if first < 0 first = last;
            }


            advance(*input);
        }

        part1 += first * 10 + last;
    }

    return tprint("%", part1), tprint("%", part1);
}