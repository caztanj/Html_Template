html_template :: (template: string, values: Table(string, string)) -> string {
    return html_template(template, values, (key: string, values: Table(string, string)) -> string {
        found, value := table_find_new(*values, key);
        if !found return tprint("<'%' NOT FOUND>", key);
        return value;
    });
}

html_template :: (template: string, user_data: $T, fn: (string, T) -> string) -> string {
    b: String_Builder;
    b.allocator = temp;

    current := template;
    while true {
        start := find_index_from_left(current, "{{");
        if start == -1 {
            append(*b, current);
            break;
        }

        end := find_index_from_left(current, "}}", start);
        if end == -1 {
            append(*b, current);
            break;
        }

        before := slice(current, 0, start);
        middle := trim(slice(current, start + 2, end - start - 2));

        value := fn(middle, user_data);

        append(*b, before);
        append(*b, safe_html(value,, temp));

        current = slice(current, end + 2, current.count - end - 2);
    }

    return builder_to_string(*b);
}

safe_html :: (attribute: string) -> string {
    // Do we need this function to handle UTF-8?

    t     := attribute.data;
    max_t := attribute.data + attribute.count;

    result: [..] u8;

    while t < max_t {
        if t.* == {
            case 0;
                array_add(*result, 0xef, 0xbf, 0xbd);

            case "\"";
                array_add(*result, "&", "#", "3", "4", ";");

            case "&";
                array_add(*result, "&", "a", "m", "p", ";");

            case "'";
                array_add(*result, "&", "#", "3", "9", ";");

            case "+";
                array_add(*result, "&", "#", "4", "3", ";");

            case "<";
                array_add(*result, "&", "l", "t", ";");

            case ">";
                array_add(*result, "&", "g", "t", ";");

            case;
                array_add(*result, t.*);
        }

        t += 1;
    }

    return result.(string);
}

#scope_module

#import "Basic";
#import "Hash_Table";
#import "String";