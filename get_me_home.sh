#!/usr/bin/env bash

start_ym="2022-12"
dates_start=(21 22 23)
end_ym="2023-01"
dates_end=(2 3 4 5 6 7 8)
json_dir="data"

for ds in ${dates_start[@]}; do
    for de in ${dates_end[@]}; do
        start_date=$(printf "%s-%02d" $start_ym $ds)
        return_date=$(printf "%s-%02d" $end_ym $de)
        fname="${json_dir}/start_${start_date}_return_${return_date}.json"
        if [[ -e $fname ]]; then
            printf "file exists, skipping %s\n" $fname
        else
            printf "Processing %s\n" $fname
            python search_flights_home.py \
                --origin "LOND" \
                --dest "SVQ" \
                --start_date ${start_date} \
                --return_date ${return_date} \
                --out_dir ${json_dir}
            sleep 8 # API has limit of 10 requests/minute
        fi
    done
done

Rscript skyscanner_data_analysis.R ${json_dir}