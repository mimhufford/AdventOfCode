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
            if popcount(segment.bits) == {
                case 2; segment.value = 1; digits[1] = segment; 
                case 4; segment.value = 4; digits[4] = segment; 
                case 3; segment.value = 7; digits[7] = segment; 
                case 7; segment.value = 8; digits[8] = segment; 
            }
        }

        find_digit(digit=9, digit_seg_count=6, compare_to=4, expected_differences=2);
        find_digit(digit=0, digit_seg_count=6, compare_to=1, expected_differences=4);
        find_digit(digit=6, digit_seg_count=6, compare_to=0, expected_differences=2);
        find_digit(digit=2, digit_seg_count=5, compare_to=9, expected_differences=3);
        find_digit(digit=3, digit_seg_count=5, compare_to=2, expected_differences=2);
        find_digit(digit=5, digit_seg_count=5, compare_to=2, expected_differences=4);

        output_value := 0;

        for segment: signal.output
        {
                 if popcount(segment.bits) == 2 part1 += 1;
            else if popcount(segment.bits) == 3 part1 += 1;
            else if popcount(segment.bits) == 4 part1 += 1;
            else if popcount(segment.bits) == 7 part1 += 1;

            for digit, value: digits
            {
                if segment.bits == digit.bits
                {
                    output_value *= 10;
                    output_value += value;
                    break;
                }
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
    bits:  u8;
    value: s8 = -1;
}

read_segment :: (segment: *Segment) #expand
{
    while `data[0] >= #char "a" && `data[0] <= #char "g"
    {
        segment.bits |= xx (1 << (`data[0] - #char "a"));
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
        if segment.value >= 0 continue;
        if digit_seg_count != popcount(segment.bits) continue;
        if expected_differences != popcount(`digits[compare_to].bits ^ segment.bits) continue;

        segment.value = digit;
        `digits[digit] = segment;
        break;                
    }
}