# Sentinel

A lightweight service and system monitoring tool written in Bash. Sentinel
checks whether websites respond, monitors local disk usage, and tracks state
changes over time so it only reports when something actually changes.

Built as a hands-on learning project to practice Bash scripting, Linux/macOS
command-line tools, and basic monitoring concepts.

## What it does

Most monitoring needs start simple: is the website up? Is the disk filling up?
Did something change since the last check? Sentinel answers these with small,
focused scripts instead of a heavy monitoring platform.

It runs on macOS and Linux using only standard command-line tools (`curl`,
`df`, `awk`), with no external dependencies.

## Components

- **`check.sh`** — checks a single URL and reports its HTTP status code.
  Follows redirects and uses a configurable default URL.
- **`check_all.sh`** — checks multiple URLs read from `services.txt`, one per
  line, using a `while read` loop.
- **`check_disk.sh`** — reports disk usage of the root volume and warns when it
  exceeds a configurable threshold (default 90%).
- **`check_state.sh`** — checks a URL and only reports when its state *changes*
  (UP to DOWN or back), by remembering the previous state in a file. This
  avoids repeated alerts for an ongoing outage.
- **`sentinel.sh`** — orchestrator that runs all checks in one command, with a
  timestamped header.

## Usage

Make the scripts executable once:

    chmod +x *.sh

Run a single check:

    ./check.sh https://github.com

Check all configured websites:

    ./check_all.sh

Check disk usage (warn above the default 90%):

    ./check_disk.sh

Or pass a custom threshold:

    ./check_disk.sh 80

Run everything at once:

    ./sentinel.sh

## Configuration

Websites to monitor are listed in `services.txt`, one URL per line:

    https://google.com
    https://github.com

## Concepts practiced

- HTTP status checking with `curl` (status codes, redirects, timeouts)
- Reading files line by line with `while read`
- Extracting fields from command output with `awk` and `tr`
- Numeric vs string comparison in Bash conditionals
- Persisting state between runs to detect changes
- Handling macOS vs Linux differences (BSD vs GNU tools)

## Notes

This is a learning project, built incrementally. It is intentionally simple and
favors readability over completeness.

## Author

Nikhil Mahtani
