main :: () {
    function_interface();
    print("\n");
    table_interface();
}

function_interface :: () {
    s := html_template(TEMPLATE, null, (key: string, user_data: *void) -> string {
        if key == {
            case "content";
                return "Some content";

            case "give_me_a_thing";
                return give_me_a_thing();

            case;
                return "";
        }
    });

    print("Function Interface:\n");
    print("%", s);
}

table_interface :: () {
    t: Table(string, string);
    table_set(*t, "content", "Content");

    s := html_template(TEMPLATE, t);

    print("Table Interface:\n");
    print("%", s);
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
        {{ give_me_a_thing }}
    </body>
</html>
HTML

#import "Basic";
#import "Compiler";
#import "Hash_Table";
#import,file "../module.jai";