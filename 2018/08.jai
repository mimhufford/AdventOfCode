day8 :: (input: string) -> string, string
{
    Node :: struct {
        children: [..]*Node;
        metadata: [..]s64;
        sum, value: s64;
    };

    parse_node :: (nodes: *[..]Node, input: *string) -> *Node {
        node := array_add(nodes);
        children := read_s64(input);
        metadata := read_s64(input);
        for 1..children array_add(*node.children, parse_node(nodes, input));
        for 1..metadata array_add(*node.metadata, read_s64(input));
        for node.metadata node.sum += it;
        for node.children node.sum += it.sum;
        if !children { node.value = node.sum; return node; }
        for node.metadata if it <= node.children.count
            node.value += node.children[it-1].value;
        return node;
    }

    nodes : [..]Node;
    array_reserve(*nodes, 5000);
    root := parse_node(*nodes, *input);
    part1, part2 := root.sum, root.value;

    return tprint("%", part1), tprint("%", part2);
}