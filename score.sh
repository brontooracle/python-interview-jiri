function normalize_score {
    python -c "import math; print(math.exp($1 * $2 / $3 + $4))"
}

function geometric_mean {
    python - "$@" << END
import sys
import math

numbers = list(map(float, sys.argv[1:]))
print(math.product(numbers) ** (1 / len(numbers)))
END
}

function times_100 {
    python -c "print(100 * $1)"
}


function compute_code_quality_score {
    echo "Computing the code quality score... "
    FLAKE8_ERRORS=$(flake8 optimize | wc -l)
    PYDOC_ERRORS=$(($(pydocstyle optimize | wc -l) / 2))
    MYPY_ERRORS=$(mypy optimize | wc -l)
    SLOC=$(pygount --suffix py optimize | awk '{sum += $1} END {print sum}')
    FLAKE8_SCORE=$(normalize_score "$FLAKE8_ERRORS" -8 "$SLOC" 0)  # exp(-8 * X / SLOC + 0)
    PYDOC_SCORE=$(normalize_score "$PYDOC_ERRORS" -8 "$SLOC" 0)  # exp(-8 * X / SLOC + 0)
    MYPY_SCORE=$(normalize_score "$MYPY_ERRORS" -8 "$SLOC" 0)  # exp(-8 * X / SLOC + 0)
    CODE_QUALITY_SCORE=$(geometric_mean "$FLAKE8_SCORE" "$PYDOC_SCORE" "$MYPY_SCORE")
#    FINAL_SCORE=$(geometric_mean "$CODE_QUALITY_SCORE" "$PERFORMANCE_SCORE")
    echo "Done!"
}

function print_final_score {
#    SCORE=$(printf "Final score                  %6.2f%%" "$(times_100 "$FINAL_SCORE")")
    SCORE=$(printf "\\n Code quality score       %6.2f%%" "$(times_100 "$CODE_QUALITY_SCORE")")
    SCORE+=$(printf "\\n    ┣━━ Flake8 score         %6.2f%% (%d flake8 errors)" "$(times_100 "$FLAKE8_SCORE")" "$FLAKE8_ERRORS")
    SCORE+=$(printf "\\n    ┣━━ Pydocstyle score     %6.2f%% (%d pydocstyle errors)" "$(times_100 "$PYDOC_SCORE")" "$PYDOC_ERRORS")
    SCORE+=$(printf "\\n    ┗━━ Mypy score           %6.2f%% (%d mypy errors)" "$(times_100 "$MYPY_SCORE")" "$MYPY_ERRORS")
    echo "$SCORE"
}

compute_code_quality_score
print_final_score
