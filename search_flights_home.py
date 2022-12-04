#!/usr/bin/env python3

import json
import requests
import dotenv
from argparse import ArgumentParser
from datetime import datetime
from pathlib import Path

url = "https://skyscanner44.p.rapidapi.com/search-extended"
api_key = dotenv.dotenv_values()['RAPIDAPI_SKYSCANNER_KEY']

def main(origin, dest, start_date, return_date=None, out_dir=None):
    start_date, return_date = parse_dates(start_date, return_date)
    querystring = {
        "adults":"1",
        "origin":origin,
        "destination":dest,
        "departureDate":start_date,
        "returnDate":return_date,
        "currency":"GBP",
        "stops":"0,1,2",
        "duration":"50", # max hours
        "startFrom":"00:00",
        "arriveTo":"23:59",
        "returnStartFrom":"00:00",
        "returnArriveTo":"23:59"
    }
    headers = {
        "X-RapidAPI-Key": api_key,
        "X-RapidAPI-Host": "skyscanner44.p.rapidapi.com"
    }
    response = requests.request("GET", url, headers=headers, params=querystring).json()
    if out_dir is None:
        out_dir = Path(__file__).parent / "data"
    out_dir = Path(out_dir)
    out_dir.mkdir(exist_ok=True)
    out_fname = out_dir / f"start_{start_date}_return_{return_date}.json"
    out_fname.write_text(json.dumps(response, indent=4))


def parse_dates(start_date, return_date=None):
    start_dt = datetime.strptime(start_date, "%Y-%m-%d")
    start_parsed = start_dt.strftime("%Y-%m-%d")
    return_parsed = None
    if return_date is not None:
        return_dt = datetime.strptime(return_date, "%Y-%m-%d")
        return_parsed = return_dt.strftime("%Y-%m-%d")
    return start_parsed, return_parsed

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("--origin", type=str, default="LOND")
    parser.add_argument("--dest", type=str, default="SVQ")
    parser.add_argument("--start_date", type=str)
    parser.add_argument("--return_date", type=str, default=None)
    parser.add_argument("--out_dir", type=str, default=None)
    args = parser.parse_args()
    main(**vars(args))
