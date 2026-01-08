day16 :: (input: string) -> string, string
{
    part1, part2 := 0;

    signal, output, running : [..]s64;
    for trim(input) array_add(*signal, (it - "0"));
    array_resize(*output, signal.count);
    array_resize(*running, signal.count + 1);

    for 1..100 {
        for 1..signal.count running[it] = running[it-1] + signal[it-1];
        for o: 0..signal.count-1 {
            for run: 0..S64_MAX {
                start := o + run*(2*o+2);
                end := min(2*o + run*(2*o+2), signal.count - 1);
                if start >= signal.count break;
                mult := ifx run % 2 then -1 else 1;
                output[o] += mult * (running[end+1] - running[start]);
            }
            output[o] = abs(output[o]) % 10;
        }
        signal, output = output, signal;
        for * output it.* = 0;
    }

    for 0..7 part1 = part1 * 10 + signal[it];

    return tprint("%", part1), tprint("%", part2);
}