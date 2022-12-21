day21 :: (input: string) -> string, string
{
    root, nodes := parse_nodes(input);

    resolve(root);

    return tprint("%", root.value), tprint("%", "");
}

#scope_file

Node :: struct
{
    name  : string;
    value : s64;
    op    : u8;
    ops   : [2]*Node;
}

resolve :: (node: *Node)
{
    if node.op == 0 return;

    resolve(node.ops[0]);
    resolve(node.ops[1]);

    if node.op == {
        case #char "+"; node.value = node.ops[0].value + node.ops[1].value;
        case #char "-"; node.value = node.ops[0].value - node.ops[1].value;
        case #char "*"; node.value = node.ops[0].value * node.ops[1].value;
        case #char "/"; node.value = node.ops[0].value / node.ops[1].value;
    }

    node.op = 0; // mark as done
}

parse_nodes :: (input: string) -> *Node, []*Node
{
    nodes : [..]*Node;

    while input
    {
        name := read_word(*input);
        name.count -= 1;

        node := find_or_add(*nodes, name);

        if is_digit(input[0])
        {
            node.value = read_s64(*input);
        }
        else
        {
            node.ops[0] = find_or_add(*nodes, read_word(*input));
            node.op     = read_word(*input)[0];
            node.ops[1] = find_or_add(*nodes, read_word(*input));
        }
    }

    return find_or_add(*nodes, "root"), nodes;

    find_or_add :: (nodes: *[..]*Node, name: string) -> *Node
    {
        for <<nodes if it.name == name return it;

        node := New(Node);
        node.name = name;
        array_add(nodes, node);
        return node;
    }
}