day16 :: (input: string) -> string, string
{
    part1, part2 := 0;

    parsed : [..]s16;
    for trim(input) array_add(*parsed, (it - "0").(s16));
    signal := array_copy(parsed);
    output := NewArray(signal.count, s16);

    for 1..100 {
        for o: 0..signal.count-1 {
            for run: 0..S64_MAX {
                start := o + run*(2*o+2);
                end := min(2*o + run*(2*o+2), signal.count - 1);
                if start >= signal.count break;
                mult := ifx run % 2 then cast(s16, -1) else cast(s16, 1);
                for start..end output[o] += mult * signal[it];
            }
            output[o] = abs(output[o]) % 10;
        }
        signal, output = output, signal;
        for * output it.* = 0;
    }

    for 0..7 part1 = part1 * 10 + signal[it];

    return tprint("%", part1), tprint("%", part2);
}