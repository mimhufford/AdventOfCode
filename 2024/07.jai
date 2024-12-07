day7 :: (input: string) -> string, string
{
    numbers : [..]s64;
    part1, part2 := 0;

    while input
    {
        array_reset_keeping_memory(*numbers);
        total := read_s64(*input);
        advance(*input, 2);
        while true
        {
            array_add(*numbers, read_number(s64, *input, skip_trailing_whitespace = false));
            defer advance(*input);
            if input[0] == #char "\n" break;
        }

        for ops: 0..cast(s64)pow(2.0, cast(float)(numbers.count-1))
        {
            value := numbers[0];
            
            for bit: 0..numbers.count-2
            {
                op := (ops >> bit) & 1;
                if op == 0 value += numbers[bit+1];
                else       value *= numbers[bit+1];
            }

            if value == total
            {
                part1 += total;
                break;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}