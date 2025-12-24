day4 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for line: split(trim(input), "\n") {
        words : Table(string, s64);
        sorts : Table(string, s64);

        found_duplicate_word := false;
        found_duplicate_sort := false;
        
        while line {
            word := read_word(*line);
            entry, new := find_or_add(*words, word);
            found_duplicate_word |= !new;
            word = copy_string(word);
            quick_sort(word.([]u8), c => c);
            entry, new = find_or_add(*sorts, word);
            found_duplicate_sort |= !new;
        }

        part1 += ifx !found_duplicate_word then 1;
        part2 += ifx !found_duplicate_sort then 1;
    }

    return tprint("%", part1), tprint("%", part2);
}