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

    part1 := 0;

    for signal: signals
    {
        for output: signal.output
        {
            count := 0;
            for segment: output.bits  if segment  count += 1;
            if count == 2 || count == 3 || count == 4 || count == 7  
            {
                part1 += 1;
            }
        }
    }

    return tprint("%", part1), tprint("%", signals.count);
}

Signal :: struct
{
    input  : [10]Segment;       
    output : [ 4]Segment;       
}

Segment :: struct
{
    a, b, c, d, e, f, g : bool;
    #place a;    bits: [7]bool;
}

read_segment :: (n: int, segment: []Segment) #expand
{
    for 0..n-1
    {
        while `data[0] >= #char "a" && `data[0] <= #char "g"
        {
            segment[it].bits[`data[0] - #char "a"] = true;
            advance(*`data, 1);
        }
        advance(*`data, 1);
    }
}