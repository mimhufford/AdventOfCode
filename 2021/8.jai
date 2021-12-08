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

        find_by_doesnt_overlap(target=6, target_seg_count=6, cant_overlap_with=1);
        find_by_doesnt_overlap(target=0, target_seg_count=6, cant_overlap_with=4);
        find_by_last_seg_count(target=9, target_seg_count=6                     );
        find_by_entire_overlap(target=5, target_seg_count=5, must_overlap_with=6);
        find_by_entire_overlap(target=3, target_seg_count=5, must_overlap_with=9);
        find_by_last_seg_count(target=2, target_seg_count=5                     );

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

find_by_doesnt_overlap :: (target: s8, cant_overlap_with: s8, target_seg_count: s8) #expand
{
    for * segment: `signal.input
    {
        if segment.count == target_seg_count && segment.value < 0
        {
            for `digits[cant_overlap_with].bits
            {
                if it && !segment.bits[it_index]
                {
                    segment.value = target;
                    `digits[target] = segment;
                    break segment;
                }
            }
        }
    }
}

find_by_last_seg_count :: (target: s8, target_seg_count: s8) #expand
{
    for * segment: `signal.input
    {
        if segment.count == target_seg_count && segment.value < 0
        {
            segment.value = target;
            `digits[target] = segment;
            break segment;
        }
    }
}

find_by_entire_overlap :: (target: s8, must_overlap_with: s8, target_seg_count: s8) #expand
{
    for * segment: `signal.input
    {
        if segment.count == target_seg_count && segment.value < 0
        {
            for segment.bits
            {
                if it && !`digits[must_overlap_with].bits[it_index]
                {
                    continue segment;
                }
            }

            segment.value = target;
            `digits[target] = segment;
            break segment;
        }
    }
}