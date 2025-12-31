day4 :: (input: string) -> string, string
{
    lines := split(trim(input), "\n");
    quick_sort(lines, (a, b) => compare(a, b));

    guards : Table(s64, [60]s64);
    id, start := 0;

    for lines {
        advance(*it, 15);
        minute := read_s64(*it);
        if it[2] == {
            case "G"; advance(*it, 9); id = read_s64(*it);
            case "f"; start = minute;
            case "w"; g := find_or_add(*guards, id); for start..minute-1 g.*[it] += 1;
        }
    }

    part1, part2 := 0;
    most_asleep, most_freq := 0;

    for sleeps, id: guards {
        most_min, most_min_count, total_sleep := 0;

        for count, min: sleeps {
            total_sleep += count;
            if count < most_min_count continue;
            most_min, most_min_count = min, count;
            if most_min_count < most_freq continue;
            part2, most_freq = most_min * id, most_min_count;
        }

        if total_sleep < most_asleep continue;
        part1, most_asleep = most_min * id, total_sleep;
    }

    return tprint("%", part1), tprint("%", part2);
}