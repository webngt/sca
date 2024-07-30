#!/bin/bash

#python3 /usr/local/lib/test_cases.py TestAssignment0

cat << EOF
{
    "Test 1": {
        "error": "err",
        "expected": [
            "Произведение = 7"
        ],
        "input": [
            "3",
            "4"
        ],
        "passed": false,
        "result": [
            "Произведение = 7"
        ],
        "should_include": "N/A"
    },
    "Test 2": {
        "error": null,
        "expected": [
            "10"
        ],
        "input": [
            "4",
            "6"
        ],
        "passed": true,
        "result": [
            "10"
        ],
        "should_include": "N/A"
    }
}
EOF