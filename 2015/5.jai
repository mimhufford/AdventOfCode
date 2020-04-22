Day5 :: () {
    input := read_entire_file("input/5.txt");

    lines := split(input, "\n");

    nice_string_v1_count := 0;

    for lines {
        if contains_bad_pair(it) continue;
        if no_duplicates(it)     continue;
        if vowel_count(it) < 3   continue;

        nice_string_v1_count += 1;
    }

    print("Day 05: Part 1: %\n", nice_string_v1_count);
    print("Day 05: Part 2: %\n", 0);
}

#scope_file

vowel_count :: (s: string) -> int {
    return count_any(s, "aeiou");
}

contains_bad_pair :: (s: string) -> bool {
    for 0..s.count-2 {
        pair : string;
        pair.data  = s.data + it;
        pair.count = 2;
        if equal(pair, "ab") return true;
        if equal(pair, "cd") return true;
        if equal(pair, "pq") return true;
        if equal(pair, "xy") return true;
    }

    return false;
}

no_duplicates :: (s: string) -> bool {
    for 0..s.count-2  if s[it] == s[it+1]  return false;
    return true;
}