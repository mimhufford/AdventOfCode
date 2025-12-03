day3 :: (input: string) -> string, string
{
    part1, part2 : s64;

    while input {
        tens_digit  := 0;
        tens_index  := 0;
        units_digit := 0;
        units_index := 0;

        for index: 0..98 {
            if input[index] - "0" <= tens_digit continue;
            tens_digit = input[index] - "0";
            tens_index = index;
            if tens_digit == 9 break;
        }

        for index: tens_index+1..99 {
            if input[index] - "0" <= units_digit continue;
            units_digit = input[index] - "0";
            units_index = index;
            if units_digit == 9 break;
        }

        part1 += 10 * tens_digit + units_digit;

        advance(*input, 101);
    }

    return tprint("%", part1), tprint("%", part2);
}