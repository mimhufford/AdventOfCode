Day2 :: () {
    input := read_entire_file("input/2.txt");

    paper_needed  := 0;
    ribbon_needed := 0;

    while input {
        l, w, h : int;
        _ : bool;

        l, _, input = string_to_int(input);
        advance(*input);

        w, _, input = string_to_int(input);
        advance(*input);

        h, _, input = string_to_int(input);
        advance(*input);

        extra := min(l*w, w*h, h*l);
        paper_needed += 2*l*w + 2*w*h + 2*h*l + extra;

        bow := 2*l+2*w+2*h - 2*max(l, w, h);
        ribbon_needed += l*w*h + bow;
    }

    print("Day 02: Part 1: %\n", paper_needed);
    print("Day 02: Part 2: %\n", ribbon_needed);
}