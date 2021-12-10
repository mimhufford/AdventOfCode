day2 :: (data: string) -> string, string {
    input := data;
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

    return tprint("%", paper_needed), tprint("%", ribbon_needed);
}