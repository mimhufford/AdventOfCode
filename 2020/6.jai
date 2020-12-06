day6 :: () -> string, string
{
    data := input(6);

    part1 := 0;

    for i: 0..data.count-1
    {
        answered := 0;
        count := 0;

        while true
        {
            if i == data.count break;

            if data[i] >= #char "a" && data[i] <= #char "z"
            {
                bit := 1 << (data[i] - #char "a");
                if !(answered & bit) count += 1;
                answered |= bit;
            }

            if data[i] == #char "\n" && data[i+1] == #char "\n" { i += 1; break; }

            i += 1;
        }

        part1 += count;
    }

    return tprint("%", part1), "";
}