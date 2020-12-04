#import "Compiler";

build :: ()
{
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
    
    // Wait for COMPLETE message
    while true
    {
        message := compiler_wait_for_message();
        if !message continue;
        if message.workspace != w continue;
        if message.kind == .COMPLETE break;
    }

    compiler_end_intercept(w);
}

#run build();