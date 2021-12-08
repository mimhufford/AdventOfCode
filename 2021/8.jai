day8 :: (data : string) -> string, string
{
    signals : [..]Signal;

    while data.count
    {
        signal : Signal;
        read_segment(10, signal.input);
        advance(*data, 2);
        read_segment( 4, signal.output);
        array_add(*signals, signal);
    }

    part1, part2 := 0;

    for signal: signals
    {
        digits : [10]Segment;

        for * segment: signal.input // find 1, 4, 7, 8
        {
            if segment.count == {
                case 2; segment.value = 1; digits[1] = <<segment; 
                case 4; segment.value = 4; digits[4] = <<segment; 
                case 3; segment.value = 7; digits[7] = <<segment; 
                case 7; segment.value = 8; digits[8] = <<segment; 
            }
        }

        for * segment: signal.input  // find 6
        {
            if segment.count == 6
            {
                for digits[1].bits
                {
                    if it && !segment.bits[it_index]
                    {
                        segment.value = 6;
                        digits[6] = <<segment;
                        break segment;
                    }
                }
            }
        }

        for * segment: signal.input // find 0
        {
            if segment.count == 6 && segment.value < 0
            {
                for digits[4].bits
                {
                    if it && !segment.bits[it_index]
                    {
                        segment.value = 0;
                        digits[0] = <<segment;
                        break segment;
                    }
                }
            }
        }

        for * segment: signal.input // find 9
        {
            if segment.count == 6 && segment.value < 0
            {
                segment.value = 9;
                digits[9] = <<segment;
                break segment;
            }
        }

        for * segment: signal.input // find 5
        {
            if segment.count == 5
            {
                for segment.bits
                {
                    if it && !digits[6].bits[it_index]
                    {
                        continue segment;
                    }
                }

                segment.value = 5;
                digits[5] = <<segment;
                break segment;
            }
        }
        
        for * segment: signal.input // find 3
        {
            if segment.count == 5 && segment.value < 0
            {
                for segment.bits
                {
                    if it && !digits[9].bits[it_index]
                    {
                        continue segment;
                    }
                }

                segment.value = 3;
                digits[3] = <<segment;
                break segment;
            }
        }

        for *segment: signal.input // find 2
        {
            if segment.value < 0
            {
                segment.value = 2;
                digits[2] = <<segment;
                break segment;
            }
        }

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
    count: u8;
    value: s8 = -1;
}

read_segment :: (n: int, segment: []Segment) #expand
{
    for 0..n-1
    {
        while `data[0] >= #char "a" && `data[0] <= #char "g"
        {
            segment[it].bits[`data[0] - #char "a"] = true;
            segment[it].count += 1;
            advance(*`data, 1);
        }
        advance(*`data, 1);
    }
}


/*

  0:6     1:2     2:5     3:5     4:4
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:5     6:6     7:3     8:7     9:6
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg


*/