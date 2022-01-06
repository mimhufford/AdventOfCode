day21 :: (data: string) -> string, string
{
    part_1 := scramble(data, "abcdefgh");

    _input := int.[97,98,99,100,101,102,103,104];
    input := permutation(_input);
    part_2 : [8]u8;
    while true {
        input = permutation(input);
        i : [8]u8; for 0..7 i[it] = xx input[it];
        result := scramble(data, xx i);
        if result == "fbgdceah"
        {
            part_2 = i;
            break;
        }
    }

    return tprint("%", part_1), tprint("%", cast(string)part_2);
}

#scope_file

#import "Permute";

scramble :: (data: string, input: string) -> string
{
    buffer : [2][8]u8;
    for 0..7 {
        buffer[0][it] = input[it];
        buffer[1][it] = input[it];
    }

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

    return tprint(cast(string)buffer[curr]);
}