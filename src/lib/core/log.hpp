#include <fstream>
#include <cstdlib>
#include <string>

namespace ols::log {

static std::ofstream logfile;

bool init() {
    const char* home = std::getenv("HOME");
    if (!home)
        return false;

    std::string path = std::string(home) + "/OLS/logs.log";
    logfile.open(path, std::ios::app);

    return logfile.is_open();
}

void info(const char* text) {
    if (!logfile.is_open()) return;
    logfile << "[ols][core] " << text << '\n';
}

void ee(const char* text) {
    if (!logfile.is_open()) return;
    logfile << "[ols][core] EE: " << text << '\n';
}

void shutdown() {
    if (logfile.is_open())
        logfile.close();
}

}
