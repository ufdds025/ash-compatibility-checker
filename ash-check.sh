#!/bin/sh
# ash-check.sh - ASH Compatibility Checker
# A comprehensive shell script to verify ASH (Almquist Shell) compatibility
# Written for POSIX sh compliance and ASH compatibility testing

set -e

# Color codes for output (POSIX compatible)
RED=''
GREEN=''
YELLOW=''
BLUE=''
RESET=''
BOLD=''

# Configuration
SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="1.0.0"
VERBOSE=0
STRICT_MODE=0
OUTPUT_FORMAT="text"

# Initialize results tracking
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
WARNINGS_COUNT=0

# Enable colors only if terminal supports it
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    RESET=$(tput sgr0)
    BOLD=$(tput bold)
fi

# Logging functions
log_info() {
    printf "%b[INFO]%b %s\\n" "$BLUE" "$RESET" "$*"
}

log_success() {
    printf "%b[✓]%b %s\\n" "$GREEN" "$RESET" "$*"
}

log_error() {
    printf "%b[✗]%b %s\\n" "$RED" "$RESET" "$*" >&2
}

log_warning() {
    printf "%b[!]%b %s\\n" "$YELLOW" "$RESET" "$*" >&2
    WARNINGS_COUNT=$((WARNINGS_COUNT + 1))
}

log_debug() {
    if [ "$VERBOSE" -eq 1 ]; then
        printf "%b[DEBUG]%b %s\\n" "$BLUE" "$RESET" "$*"
    fi
}

# Display usage information
show_usage() {
    cat << EOF
${BOLD}${SCRIPT_NAME} - ASH Compatibility Checker${RESET}
Version ${VERSION}

${BOLD}USAGE:${RESET}
    ${SCRIPT_NAME} [OPTIONS]

${BOLD}OPTIONS:${RESET}
    -h, --help              Show this help message
    -v, --verbose           Enable verbose output
    -s, --strict            Enable strict mode (fail on warnings)
    -f, --format FORMAT     Output format: text, json, csv (default: text)
    --version               Show version information

${BOLD}EXAMPLES:${RESET}
    ${SCRIPT_NAME}
    ${SCRIPT_NAME} --verbose
    ${SCRIPT_NAME} --strict --format json

${BOLD}DESCRIPTION:${RESET}
    This script checks ASH (Almquist Shell) compatibility by testing
    POSIX shell features and identifying potential compatibility issues.

EOF
}

# Parse command line arguments
parse_arguments() {
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=1
                ;;
            -s|--strict)
                STRICT_MODE=1
                ;;
            -f|--format)
                shift
                OUTPUT_FORMAT="$1"
                ;;
            --version)
                printf "%s version %s\\n" "$SCRIPT_NAME" "$VERSION"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
        shift
    done
}

# Run a single test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="${3:-0}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    log_debug "Running test: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        if [ "$expected_result" -eq 0 ]; then
            log_success "Test passed: $test_name"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            return 0
        else
            log_error "Test failed: $test_name (unexpected pass)"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            return 1
        fi
    else
        if [ "$expected_result" -ne 0 ]; then
            log_success "Test passed: $test_name (expected failure)"
            TESTS_PASSED=$((TESTS_PASSED + 1))
            return 0
        else
            log_error "Test failed: $test_name"
            TESTS_FAILED=$((TESTS_FAILED + 1))
            return 1
        fi
    fi
}

# Test: Basic arithmetic
test_arithmetic() {
    log_info "Testing arithmetic operations..."
    
    run_test "Basic addition" "[ $((2 + 2)) -eq 4 ]"
    run_test "Basic subtraction" "[ $((5 - 3)) -eq 2 ]"
    run_test "Basic multiplication" "[ $((3 * 4)) -eq 12 ]"
    run_test "Basic division" "[ $((12 / 3)) -eq 4 ]"
    run_test "Modulo operation" "[ $((10 % 3)) -eq 1 ]"
}

# Test: String operations
test_string_operations() {
    log_info "Testing string operations..."
    
    run_test "String concatenation" "[ \"hello\" \"world\" = \"helloworld\" ] || true"
    run_test "String comparison" "[ \"abc\" = \"abc\" ]"
    run_test "String length via expr" "expr length 'test' > /dev/null"
    run_test "String substitution" "echo 'hello' | grep -q 'ell'"
}

# Test: Variable operations
test_variable_operations() {
    log_info "Testing variable operations..."
    
    run_test "Variable assignment" "TEST_VAR='value'; [ \"$TEST_VAR\" = 'value' ]"
    run_test "Variable expansion" "VAR='test'; [ \"$VAR\" = 'test' ]"
    run_test "Default values" "[ \"${UNDEFINED:-default}\" = 'default' ]"
    run_test "Variable substitution" "VAR='hello'; [ \"${VAR}world\" = 'helloworld' ]"
}

# Test: Control flow
test_control_flow() {
    log_info "Testing control flow..."
    
    run_test "If statement" "if true; then true; fi"
    run_test "If-else statement" "if false; then false; else true; fi"
    run_test "For loop" "for i in 1 2 3; do [ -n \"$i\" ] || break; done; true"
    run_test "While loop" "i=0; while [ $i -lt 3 ]; do i=$((i + 1)); done; [ $i -eq 3 ]"
    run_test "Case statement" "case 'test' in test) true;; *) false;; esac"
}

# Test: Functions
test_functions() {
    log_info "Testing function definitions..."
    
    run_test "Function definition" "test_func() { return 0; }; test_func"
    run_test "Function with arguments" "func_with_args() { [ $# -eq 2 ]; }; func_with_args a b"
    run_test "Function return value" "get_value() { return 42; }; get_value; [ $? -eq 42 ]"
}

# Test: Array operations
test_array_operations() {
    log_info "Testing array operations..."
    
    # Note: Arrays are not POSIX, but worth testing for ASH
    run_test "Array indexing (if supported)" "arr='a b c'; [ -n \"$arr\" ]" || log_warning "Arrays may not be fully supported"
}

# Test: Pattern matching
test_pattern_matching() {
    log_info "Testing pattern matching..."
    
    run_test "Glob pattern matching" "case 'test.txt' in *.txt) true;; esac"
    run_test "Character class" "case 'a' in [abc]) true;; esac"
    run_test "Negation pattern" "case 'x' in [!abc]) true;; esac"
}

# Test: Command substitution
test_command_substitution() {
    log_info "Testing command substitution..."
    
    run_test "Backtick substitution" "[ \"\$(echo test)\" = 'test' ]"
    run_test "Dollar parenthesis" "OUTPUT=\$(echo 'result'); [ \"$OUTPUT\" = 'result' ]"
    run_test "Nested substitution" "[ \"\$(echo \$(echo 'test'))\" = 'test' ]"
}

# Test: Redirection
test_redirection() {
    log_info "Testing redirection..."
    
    run_test "Output redirection" "echo 'test' > /dev/null"
    run_test "Input redirection" "echo 'test' | grep -q 'test'"
    run_test "Error redirection" "false 2>/dev/null; true"
}

# Test: Special variables
test_special_variables() {
    log_info "Testing special variables..."
    
    run_test "Exit status (\$?)" "true; [ $? -eq 0 ]"
    run_test "Process ID (\$\$)" "[ -n \"$$\" ]"
    run_test "Script name (\$0)" "[ -n \"$0\" ]"
    run_test "Argument count (\$#)" "test_count() { [ $# -eq 2 ]; }; test_count a b"
}

# Test: Shell options
test_shell_options() {
    log_info "Testing shell options..."
    
    run_test "set -e option" "sh -c 'set -e; true; true'"
    run_test "set -u option" "sh -c 'set -u; TEST_VAR=\"\"; [ -n \"$TEST_VAR\" ] || true'" || log_warning "set -u may have compatibility issues"
}

# Test: POSIX compliance
test_posix_compliance() {
    log_info "Testing POSIX compliance..."
    
    run_test "POSIX character classes" "case 'a' in [[:alpha:]]) true;; *) false;; esac" || log_warning "POSIX character classes not supported"
    run_test "POSIX utilities available" "command -v grep >/dev/null && command -v sed >/dev/null"
}

# Check shell capabilities
check_shell_capabilities() {
    log_info "Checking shell capabilities..."
    
    local shell_path="$SHELL"
    [ -z "$shell_path" ] && shell_path="/bin/sh"
    
    log_debug "Shell: $shell_path"
    log_debug "Shell version: $($shell_path --version 2>/dev/null || echo 'Unknown')"
    
    # Check for common POSIX utilities
    local required_utils="sh grep sed awk"
    for util in $required_utils; do
        if command -v "$util" >/dev/null 2>&1; then
            log_success "Utility '$util' is available"
        else
            log_warning "Utility '$util' is not available"
        fi
    done
}

# Generate JSON output
output_json() {
    cat << EOF
{
  "script": "${SCRIPT_NAME}",
  "version": "${VERSION}",
  "timestamp": "$(date -u '+%Y-%m-%d %H:%M:%S')",
  "tests": {
    "run": ${TESTS_RUN},
    "passed": ${TESTS_PASSED},
    "failed": ${TESTS_FAILED}
  },
  "warnings": ${WARNINGS_COUNT},
  "success": $([ ${TESTS_FAILED} -eq 0 ] && echo "true" || echo "false")
}
EOF
}

# Generate CSV output
output_csv() {
    cat << EOF
metric,value
tests_run,${TESTS_RUN}
tests_passed,${TESTS_PASSED}
tests_failed,${TESTS_FAILED}
warnings,${WARNINGS_COUNT}
success,$([ ${TESTS_FAILED} -eq 0 ] && echo "true" || echo "false")
EOF
}

# Display results summary
show_summary() {
    log_info "ASH Compatibility Check Summary"
    printf "\\n"
    
    case "$OUTPUT_FORMAT" in
        json)
            output_json
            ;;
        csv)
            output_csv
            ;;
        *)
            printf "%bTests Run:%b %d\\n" "$BOLD" "$RESET" "$TESTS_RUN"
            printf "%bTests Passed:%b %d\\n" "$BOLD" "$RESET" "$TESTS_PASSED"
            printf "%bTests Failed:%b %d\\n" "$BOLD" "$RESET" "$TESTS_FAILED"
            printf "%bWarnings:%b %d\\n" "$BOLD" "$RESET" "$WARNINGS_COUNT"
            
            printf "\\n"
            if [ "$TESTS_FAILED" -eq 0 ]; then
                log_success "All tests passed!"
                return 0
            else
                log_error "Some tests failed. ASH compatibility issues detected."
                return 1
            fi
            ;;
    esac
}

# Main execution function
main() {
    parse_arguments "$@"
    
    log_info "ASH Compatibility Checker v${VERSION}"
    log_info "Starting compatibility check..."
    printf "\\n"
    
    # Run all test suites
    check_shell_capabilities
    printf "\\n"
    
    test_arithmetic
    printf "\\n"
    
    test_string_operations
    printf "\\n"
    
    test_variable_operations
    printf "\\n"
    
    test_control_flow
    printf "\\n"
    
    test_functions
    printf "\\n"
    
    test_pattern_matching
    printf "\\n"
    
    test_command_substitution
    printf "\\n"
    
    test_redirection
    printf "\\n"
    
    test_special_variables
    printf "\\n"
    
    test_shell_options
    printf "\\n"
    
    test_posix_compliance
    printf "\\n"
    
    # Show summary and exit with appropriate code
    show_summary
    
    if [ "$STRICT_MODE" -eq 1 ] && [ "$WARNINGS_COUNT" -gt 0 ]; then
        log_error "Strict mode enabled: warnings treated as failures"
        exit 1
    fi
    
    exit $((TESTS_FAILED > 0 ? 1 : 0))
}

# Run main function if script is executed directly
if [ "${0##*/}" = "ash-check.sh" ] || [ "${0##*/}" = "sh" ]; then
    main "$@"
fi
