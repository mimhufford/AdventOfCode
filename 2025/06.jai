day6 :: (input: string) -> string, string
{
    part1, part2 : s64;

    {
        data := input;
        numbers : [1000][4]s64;

        for row: 0..3 {
            for col: 0..999 {
                numbers[col][row] = read_s64(*data);
            }
        }

        for col: 0..999 {
            op := read_word(*data);
            answer := numbers[col][0];
            if op == "+" for 1..3 answer += numbers[col][it];
            else         for 1..3 answer *= numbers[col][it];
            part1 += answer;
        }
    }

    {
        data := input;
        length := read_up_to(*data, "\n").count;

        op : u8;
        answer := 0;

        for col: 0..length-1 {
            digits : [5]u8;
            for 0..4 digits[it] = input[col + (it * (length+1))];

            if digits[4] == "+" then { op = "+"; answer = 0; }
            if digits[4] == "*" then { op = "*"; answer = 1; }

            blank_column := true;
            for digits if it != " " then blank_column = false;
            if blank_column { part2 += answer; continue; }

            number := 0;
            for 0..3 if digits[it] != " " {
                number *= 10;
                number += (digits[it] - "0").(s64);
            }

            answer = ifx op == "+" then answer + number else answer * number;
        }

        part2 += answer;
    }

    return tprint("%", part1), tprint("%", part2);
}