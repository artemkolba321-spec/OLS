#include "kernel.hpp"
#include "log.hpp"

#include <cstdlib>
#include <string>
#include <unistd.h>

namespace ols::kernel {

static std::string home() {
    const char* h = getenv("HOME");
    return h ? h : "";
}

int dispatch(int argc, char** argv) {
    std::string invoked = argv[0];
    auto pos = invoked.find_last_of('/');
    if (pos != std::string::npos)
        invoked = invoked.substr(pos + 1);

    std::string cmd;
    if (invoked == "ols") {
        if (argc < 2) {
            ols::log::error("no command");
            return 1;
        }
        cmd = argv[1];
        argv++;
        argc--;
    } else {
        cmd = invoked;
    }

    std::string script =
        home() + "/OLS/scripts/" + cmd;

    if (access(script.c_str(), X_OK) != 0) {
        ols::log::error("command not found: " + cmd);
        return 127;
    }

    std::string full = script;
    for (int i = 1; i < argc; ++i) {
        full += " ";
        full += argv[i];
    }

    ols::log::info("exec: " + full);
    return system(full.c_str());
}

}

