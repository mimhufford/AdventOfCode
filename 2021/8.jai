day8 :: (data : string) -> string, string
{
    signals : [..]Signal;

    while data.count
    {
        signal : Signal;
        for 0..9 read_segment(*signal.input[it]);
        for 0..3 read_segment(*signal.output[it]);
        array_add(*signals, signal);
    }

    part1, part2 := 0;

    for signal: signals
    {
        digits : [10]*Segment;

        for * segment: signal.input // find 1, 4, 7, 8
        {
            if segment.count == {
                case 2; segment.value = 1; digits[1] = segment; 
                case 4; segment.value = 4; digits[4] = segment; 
                case 3; segment.value = 7; digits[7] = segment; 
                case 7; segment.value = 8; digits[8] = segment; 
            }
        }

        find_digit(digit=9, digit_seq_count=6, compare_to=4, expected_differences=2);
        find_digit(digit=0, digit_seq_count=6, compare_to=1, expected_differences=4);
        find_digit(digit=6, digit_seq_count=6, compare_to=0, expected_differences=2);
        find_digit(digit=2, digit_seq_count=5, compare_to=9, expected_differences=3);
        find_digit(digit=3, digit_seq_count=5, compare_to=2, expected_differences=2);
        find_digit(digit=5, digit_seq_count=5, compare_to=2, expected_differences=4);

        output_value := 0;

        for segment: signal.output
        {
                 if segment.count == 2 part1 += 1;
            else if segment.count == 3 part1 += 1;
            else if segment.count == 4 part1 += 1;
            else if segment.count == 7 part1 += 1;

            for digit, value: digits
            {
                for bit, bit_index: digit.bits
                {
                    if bit != segment.bits[bit_index]
                    {
                        continue digit;
                    }
                }

                output_value *= 10;
                output_value += value;
                break digit;
            }
        }

        part2 += output_value;
    }

    return tprint("%", part1), tprint("%", part2);
}

Signal :: struct
{
    input  : [10]Segment;       
    output : [ 4]Segment;       
}

Segment :: struct
{
    bits:  [7]bool;
    count: s8;
    value: s8 = -1;
}

read_segment :: (segment: *Segment) #expand
{
    while `data[0] >= #char "a" && `data[0] <= #char "g"
    {
        segment.bits[`data[0] - #char "a"] = true;
        segment.count += 1;
        advance(*`data, 1);
    }

    while `data.count && (`data[0] < #char "a" || `data[0] > #char "g")
    {
        advance(*`data, 1);
    }
}

find_digit :: (digit: s8, digit_seg_count: s8, compare_to: s8, expected_differences: s8) #expand
{
    for * segment: `signal.input
    {
        if segment.count != digit_seg_count || segment.value >= 0 continue;

        differences := 0;
        for segment.bits if it != `digits[compare_to].bits[it_index] differences += 1;
        if differences != expected_differences continue;

        segment.value = digit;
        `digits[digit] = segment;
        break;                
    }
}