day8 :: (data : string) -> string, string
{
    signals : [..]Signal;

    while data.count
    {
        signal : Signal;

        for 0..9
        {
            while data[0] >= #char "a" && data[0] <= #char "g"
            {
                signal.input[it][data[0] - #char "a"] = true;
                advance(*data, 1);
            }
            advance(*data, 1);
        }

        advance(*data, 2);

        for 0..3
        {
            while data[0] >= #char "a" && data[0] <= #char "g"
            {
                signal.output[it][data[0] - #char "a"] = true;
                advance(*data, 1);
            }
            advance(*data, 1);
        }

        array_add(*signals, signal);
    }

    part1 := 0;

    for signal: signals
    {
        for output: signal.output
        {
            count := 0;
            for segment: output  if segment  count += 1;
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
    input  : [10][7]bool;       
    output : [ 4][7]bool;       
}