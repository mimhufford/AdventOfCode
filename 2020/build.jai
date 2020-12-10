#import "Basic";
#import "Compiler";
#import "File_Utilities";

#run {
    // Configure this workspace
    opts := get_build_options();
    opts.output_type = .NO_OUTPUT;
    set_build_options(opts);

    // Configure executable's workspace
    opts.output_type = .EXECUTABLE;
    opts.output_executable_name = "2020";
    set_optimization_level(*opts, 3, 0);
    w := compiler_create_workspace();
    compiler_begin_intercept(w);
    set_build_options(opts, w);
    add_build_file("2020.jai", w);

    // Include day files and generate days procedure array
    day_funcs : String_Builder;
    append(*day_funcs, "days := #type (string) -> (string, string).[");
    for 1..25 {
        file := tprint("%.jai", it);
        if !file_exists(file) continue;
        append(*day_funcs, tprint("day%,", it));
        add_build_file(file, w);
    }
    append(*day_funcs, "];");
    add_build_string(builder_to_string(*day_funcs), w);

    // Wait for COMPLETE message
    while true {
        msg := compiler_wait_for_message();
        if !msg continue;
        if msg.workspace == w && msg.kind == .COMPLETE break;
    }

    compiler_end_intercept(w);
};