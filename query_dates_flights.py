#!/usr/bin/env python3

import yaml
import dateutil
from itertools import product
from pathlib import Path
from argparse import ArgumentParser
from sky_utils import query_sky_api
from dateutil.rrule import DAILY, rrule

def main(force=False):
    with open("params.yaml") as f:
        query_parameters = yaml.safe_load()
    star_end_combinations = get_date_combinations(query_parameters)
    for start, end in star_end_combinations:
        json_dir = query_parameters['json_dir']
        start_date = start.strftime("%Y-%m-%d"),
        return_date = end.strftime("%Y-%m-%d"),
        combi_fname=f"{json_dir}/start_{start_date}_return_{return_date}.json"
        if Path(combi_fname).is_file():
            continue
        query_sky_api(
            origin=query_parameters['from'],
            dest=query_parameters['to'],
            start_date=start_date,
            return_date=return_date,
            out_dir=json_dir
        )

    
def get_date_combinations(query_parameters):
    there_start = query_parameters['start_date_first']
    there_end   = query_parameters['start_date_first']
    start_dates = rrule(freq=DAILY, dtstart=there_start, until=there_end)
    back_start = query_parameters['end_date_first']
    back_end   = query_parameters['end_date_first']
    end_dates = rrule(freq=DAILY, dtstart=back_start, until=back_end)
    return product(start_dates, end_dates)

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument('--force', action='store_true')
    args = parser.parse_args()
    main(force = args.force)