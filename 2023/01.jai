day1 :: (input: string) -> string, string
{
    part1, part2 := 0, 0;

    while input.count
    {
        first_dig, last_dig := -1, -1;
        first_num, last_num := -1, -1;

        while input.count
        {   
            if is_whitespace(input[0])
            {
                advance(*input);
                break;
            } 
            else if is_digit(input[0])
            {
                last_dig, last_num = input[0] - #char "0";
            }
            else if starts_with(input, "one")   last_num = 1;
            else if starts_with(input, "two")   last_num = 2;
            else if starts_with(input, "three") last_num = 3;
            else if starts_with(input, "four")  last_num = 4;
            else if starts_with(input, "five")  last_num = 5;
            else if starts_with(input, "six")   last_num = 6;
            else if starts_with(input, "seven") last_num = 7;
            else if starts_with(input, "eight") last_num = 8;
            else if starts_with(input, "nine")  last_num = 9;

            advance(*input);

            if first_dig < 0 first_dig = last_dig;
            if first_num < 0 first_num = last_num;
        }

        part1 += first_dig * 10 + last_dig;
        part2 += first_num * 10 + last_num;
    }

    return tprint("%", part1), tprint("%", part2);
}