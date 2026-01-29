#include "log.hpp"
#include <unordered_map>

namespace {
    std::unordered_map<std::string, ols::registry::CommandFn> cmds;
}

namespace ols::registry {

void register_cmd(const std::string& name, CommandFn fn) {
    cmds[name] = fn;
    ols::log::info("registered command: " + name);
}

bool exists(const std::string& name) {
    return cmds.count(name) != 0;
}

int run(const std::string& name, int argc, char** argv) {
    if (!exists(name)) {
        ols::log::ee("unknown command: " + name);
        return 127;
    }
    return cmds[name](argc, argv);
}

}

