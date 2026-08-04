local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node


ls.add_snippets("cpp",{
    s("in", {
        t({
            "#include <iostream>",
            "using namespace std;",
            "",
            "int main(){",
            "",
            "    ",   -- second blank line (cursor here)
        }),
        i(0),
        t({
            "",
            "",
            "    return 0;",
            "}"
        }),
    }),

    s("cp", {
        t({
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "",
            "int main(){",
            "    ios_base::sync_with_stdio(false);",
            "    cin.tie(nullptr);",
            "",
            "    ",
        }),
        t({""}),   -- blank line 1
        t({"    "}),
        i(0),      -- blank line 2 (cursor here)
        t({
            "",
            "    ", -- blank line 3
            "",
            "    return 0;",
            "}"
        }),
    }),

})



ls.add_snippets("c",{
    s("in", {
        t({
            "#include <stdio.h>",
            "",
            "int main(){",
            "",
            "    ",   -- second blank line (cursor here)
        }),
        i(0),
        t({
            "",
            "",
            "    return 0;",
            "}"
        }),
    }),
})

-- "watch : https://www.youtube.com/watch?v=FmHhonPjvvA"
