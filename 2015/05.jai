day5 :: (input: string) -> string, string {
    lines := split(input, "\n");

    nice_string_v1_count := 0;
    for lines {
        if contains_bad_pair(it) continue;
        if no_duplicates(it)     continue;
        if vowel_count(it) < 3   continue;

        nice_string_v1_count += 1;
    }

    nice_string_v2_count := 0;

    for lines
        if xyx_situation(it) && xy_xy_situation(it)
            nice_string_v2_count += 1;

    return tprint("%", nice_string_v1_count), tprint("%", nice_string_v2_count);
}

#scope_file

xyx_situation :: (s: string) -> bool {
    for 0..s.count-3 if s[it] == s[it+2] return true;
    return false;
}

xy_xy_situation :: (s: string) -> bool {
    return false; // TODO
}

vowel_count :: (s: string) -> int {
    count : int;
    for 0..s.count-1 {
             if s[it] == #char "a" count += 1;
        else if s[it] == #char "e" count += 1;
        else if s[it] == #char "i" count += 1;
        else if s[it] == #char "o" count += 1;
        else if s[it] == #char "u" count += 1;
    }
    return count;
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