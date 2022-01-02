day8 :: (data: string) -> string, string
{
    buffer: [2][6][50]u8;
    grid := 0;

    lines := split(data, "\n");
    lines.count -= 1;

    for line: lines
    {
        curr := grid;
        next := 1 - grid;

        if line[1] == #char "e"
        {
            advance(*line, 5);
            w := next_u32(*line);
            h := next_u32(*line);
            for 0..h-1 memset(buffer[next][it].data, 1, w);
        }
        else if line[7] == #char "r"
        {
            advance(*line, 13);
            row := next_u32(*line);
            rot := next_u32(*line);
            memcpy(buffer[next][row].data, buffer[curr][row].data + 50 - rot, rot);
            memcpy(buffer[next][row].data + rot, buffer[curr][row].data, 50 - rot);
        }
        else
        {
            advance(*line, 16);
            col := next_u32(*line);
            rot := next_u32(*line);
            for 0..5 buffer[next][it][col] = buffer[curr][(it-rot+6) % 6][col];
        }

        memcpy(buffer[curr].data, buffer[next].data, 60*5);
        grid = next;
    }

    if false
    {
        for row: buffer[1-grid]
        {
            for row print("%", ifx it then "#" else " ");
            print("\n");
        }
        print("\n");
    }

    count := 0;
    for row: buffer[1-grid] for row if it count += 1;

    return tprint("%", count), tprint("%", "AFBUPZBJPS");
}