day16 :: (input: string) -> string, string
{
    part1, part2 := 0;

    parsed : [..]s16;
    for trim(input) array_add(*parsed, (it - "0").(s16));
    signal := array_copy(parsed);
    output := NewArray(signal.count, s16);

    for 1..100 {
        for o: 0..signal.count-1 {
            start, end := o, 2 * o;
            for run: 0..S64_MAX {
                mult := ifx run % 2 then cast(s16, -1) else cast(s16, 1);
                for i: start..end {
                    if i >= signal.count break run;
                    output[o] += mult * signal[i];
                }
                start, end += 2 * o + 2;
            }
            output[o] = abs(output[o]) % 10;
        }
        signal, output = output, signal;
        for * output it.* = 0;
    }

    for 0..7 part1 = part1 * 10 + signal[it];

    return tprint("%", part1), tprint("%", part2);
}