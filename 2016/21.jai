day21 :: (data: string) -> string, string
{
    buffer : [2][8]u8 = .[
        .[#char "a", #char "b", #char "c", #char "d", #char "e", #char "f", #char "g", #char "h"],
        .[#char "a", #char "b", #char "c", #char "d", #char "e", #char "f", #char "g", #char "h"],
    ];

    curr := 0;
    next := 1;

    for line: split(data, "\n")
    {
        if starts_with(line, "swap pos")
        {
            advance(*line, 14);
            a := next_u8(*line);
            b := next_u8(*line);
            buffer[next][a] = buffer[curr][b];
            buffer[next][b] = buffer[curr][a];
        }
        else if starts_with(line, "swap let")
        {
            advance(*line, 12);
            a := line[0];
            advance(*line, 14);
            b := line[0];
            for 0..buffer[next].count-1
            {
                if buffer[curr][it] == a  buffer[next][it] = b;
                if buffer[curr][it] == b  buffer[next][it] = a;
            }
        }
        else if starts_with(line, "rotate based")
        {
            amt := 0;
            for 0..buffer[next].count-1
            {
                if buffer[curr][it] == line[line.count-1]
                {
                    amt = it;
                    break;
                }
            }
            if amt >= 4 amt += 1;
            amt += 1;

            for 0..buffer[next].count-1
                buffer[next][it] = buffer[curr][(it-amt+2*buffer[curr].count) % buffer[curr].count];
        }
        else if starts_with(line, "rotate left")
        {
            advance(*line, 12);
            amt := next_u8(*line);
            for 0..buffer[next].count-1
                buffer[next][it] = buffer[curr][(it+amt) % buffer[curr].count];
        }
        else if starts_with(line, "rotate right")
        {
            advance(*line, 13);
            amt := next_u8(*line);
            for 0..buffer[next].count-1
                buffer[next][it] = buffer[curr][(it-amt+buffer[curr].count) % buffer[curr].count];
        }
        else if starts_with(line, "reverse")
        {
            advance(*line, 18);
            a := next_u8(*line);
            b := next_u8(*line);
            d := b - a;
            for 0..d
                buffer[next][it+a] = buffer[curr][b-it];
        }
        else if starts_with(line, "move")
        {
            advance(*line, 14);
            a := next_u8(*line);
            b := next_u8(*line);
            for a..buffer[next].count-2      buffer[next][it] = buffer[next][it+1];
            for < buffer[next].count-1..b+1  buffer[next][it] = buffer[next][it-1];
            buffer[next][b] = buffer[curr][a];
        }

        buffer[curr] = buffer[next];
        curr = 1 - curr;
        next = 1 - next;
    }

    return tprint("%", cast(string)buffer[curr]), tprint("%", "");
}