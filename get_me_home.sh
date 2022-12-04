#!/usr/bin/env bash

if [[ $1 == '--force' ]]; then
    python3 query_dates_flights.py --force
elif [[ $1 == '' ]]; then
    python3 query_dates_flights.py
else
    echo "Wrong parameter, only optional parameter `--force` is valid"
    exit 1
fi

Rscript skyscanner_data_analysis.R