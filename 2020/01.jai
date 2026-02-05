day1 :: (data: string) -> string, string
{
    part1, part2 : string;

    entries : [..]int;
    nums := split(data, "\n");
    for nums array_add(*entries, string_to_int(it));
    last_index := entries.count - 1;

    for i1 : 0..last_index
    {
        e1 := entries[i1];

        for i2 : i1+1..last_index
        {
            e2 := entries[i2];

            if e1 + e2 == 2020
            {
                part1 = tprint("%", e1 * e2);
                if part2 return part1, part2;
            } 

            if e1 + e2 >= 2020  continue;

            for i3 : i2+1..last_index
            {
                e3 := entries[i3];

                if e1 + e2 + e3 == 2020
                {
                    part2 = tprint("%", e1 * e2 * e3);
                    if part1 return part1, part2;
                } 
            }
        }
    }

    return part1, part2;
}