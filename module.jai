template_to_string_from_environment :: (content: string) -> string #expand {
    #insert -> string {
        Part :: struct {
            type: enum {
                String_Literal;
                Expression;
            }
            value: string;
        }

        parts: [..] Part;

        current := content;

        while true {
            start := find_index_from_left(current, "{{");
            if start == -1 {
                array_add(*parts, .{ type = .String_Literal, value = current });
                break;
            }

            end := find_index_from_left(current, "}}", start);
            if end == -1 {
                array_add(*parts, .{ type = .String_Literal, value = current });
                break;
            }

            before := slice(current, 0, start);
            middle := slice(current, start + 2, end - 2 - start);

            array_add(*parts, .{ type = .String_Literal, value = before });
            array_add(*parts, .{ type = .Expression, value = trim(middle) });

            current = slice(current, end + 2, current.count - end - 2);
        }

        b: String_Builder;

        append(*b, "return sprint(#string HTML\n");

        for parts {
            if #complete it.type == {
                case .String_Literal;
                    append(*b, it.value);
                case .Expression;
                    append(*b, "%");
            }
        }

        append(*b, "HTML");

        for parts {
            if it.type == .Expression {
                append(*b, ", `");
                append(*b, it.value);
            }
        }

        append(*b, ");");

        return builder_to_string(*b);
    };
}

#scope_module

#import "Basic";
#import "String";