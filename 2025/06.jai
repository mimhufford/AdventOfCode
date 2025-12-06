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
            d1 := input[col + (0 * (length+1))];
            d2 := input[col + (1 * (length+1))];
            d3 := input[col + (2 * (length+1))];
            d4 := input[col + (3 * (length+1))];
            ch := input[col + (4 * (length+1))];

            if d1 == " " && d2 == " " && d3 == " " && d4 == " " && ch == " " {
                part2 += answer;
                continue;
            }

            if ch == "+" then { op = "+"; answer = 0; }
            if ch == "*" then { op = "*"; answer = 1; }

            number := 0;
            seen := false;
            
            if d1 != " " {
                seen = true;
                number *= 10;
                number += (d1 - "0").(s64);
            }

            if d2 != " " {
                seen = true;
                number *= 10;
                number += (d2 - "0").(s64);
            }

            if d3 != " " {
                seen = true;
                number *= 10;
                number += (d3 - "0").(s64);
            }

            if d4 != " " {
                seen = true;
                number *= 10;
                number += (d4 - "0").(s64);
            }

            if op == "+" answer += number;
            else         answer *= number;
        }

        part2 += answer;
    }

    return tprint("%", part1), tprint("%", part2);
}