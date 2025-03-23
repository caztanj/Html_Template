main :: () {
    content := "Hello";

    s := template_to_string_from_environment(TEMPLATE);

    print("%\n", s);
}

give_me_a_thing :: () -> string {
    return "A thing";
}

#run {
    set_build_options_dc(.{ do_output = false });
    main();
}

TEMPLATE :: #string HTML
<html>
    <head>
    </head>
    <body>
        {{ content }}
        {{ give_me_a_thing() }}
    </body>
</html>
HTML

#import "Basic";
#import "Compiler";
#import,file "../module.jai";