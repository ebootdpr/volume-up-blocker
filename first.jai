#import "Compiler";
#import "Basic";
#import "Process";
#import "File";

OUTPUT_EXECUTABLE_NAME :: "volumeupblocker";
OUTPUT_BUILD_DIR :: "";

#run {
    set_build_options_dc(.{do_output = false});
    w := compiler_create_workspace("Target workspace");
    options := get_build_options(w);
   
    copy_commonly_propagated_fields(get_build_options(), *options); //If you dont do this, then -x64 doesnt work
    options.output_executable_name = OUTPUT_EXECUTABLE_NAME;
    options.output_path = OUTPUT_BUILD_DIR;
    set_build_options(options, w);
    // compiler_begin_intercept(w); //* not needed, but, for android and linking interceptions, it is needed. 
    add_build_file("source/main.jai",w); //compilin starts here on another thread process
}