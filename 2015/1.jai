Day1 :: () {
    input := read_entire_file("input/1.txt");

    floor := 0;
    first_basement := 0;

    for 0..input.count-1 {
        if input[it] == #char "("
            floor += 1;
        else
            floor -= 1;

        if floor < 0 && first_basement == 0
            first_basement = it + 1;
    }

    print("Day 01: Part 1: %\n", floor);
    print("Day 01: Part 2: %\n", first_basement);
}