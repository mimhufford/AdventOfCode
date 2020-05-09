Day4 :: () {
    input := read_entire_file("input/4.txt");

    #import "md5";

    index   := 0;
    found_5 := 0;
    found_6 := 0;

    new_context := context;
    new_context.allocator = __temporary_allocator;

    push_context new_context 
    {
        // @TODO: very slow
        while !found_6 {
            reset_temporary_storage();
            index += 1;
            in := tprint("%1%2", input, index);
            out := md5(in);
            if !starts_with(out, "00000") continue;
            if !found_5                   found_5 = index;
            if starts_with(out, "000000") found_6 = index;
        }
    }

    print("Day 04: Part 1: %\n", found_5);
    print("Day 04: Part 2: %\n", found_6);
}