<h1 align='center'> 🌍 Get me home 🛫 </h1>

<p align="center">
    If you've ever planned a holiday where the start and end date are not fixed,
    you may have gone crazy trying to find the best flights from all combinations
    <br> 
    Fret no more!
    <br> 
    Using the SkyScanner API, you can get get all flights from a range of dates
    and collect them in a single spreadsheet.
    <br> 
</p>

## 📝 Table of Contents
- [📝 Table of Contents](#-table-of-contents)
- [🧐 About ](#-about-)
- [🏁 Getting Started ](#-getting-started-)
  - [Prerequisites](#prerequisites)
  - [Installing dependencies](#installing-dependencies)
  - [Sign up to RapidAPI and set up API Key](#sign-up-to-rapidapi-and-set-up-api-key)
- [🎈 Usage ](#-usage-)
- [🎉 Acknowledgements ](#-acknowledgements-)

## 🧐 About <a name = "about"></a>
SkyScanner is a great resources, but checking many combinations is cumbersome.
This tool automates querying the Skyscanner API and displays all the information condensed in a single spreadsheet.

## 🏁 Getting Started <a name = "getting_started"></a>

### Prerequisites
- Python >= 3.7
- R >= 4.0
- A [RapidAPI](https://rapidapi.com/hub) account subscribed to the [3B Data SkyScanner API](https://rapidapi.com/3b-data-3b-data-default/api/skyscanner44/pricing) 

### Installing dependencies
For the python dependencies, run from the terminal:
```shell
pip install requests python-dotenv python-dateutil pyyaml
```

For the R ones, start an R session and run
```R
install.packages("tidyverse")
install.packages("yaml")
```

### Sign up to RapidAPI and set up API Key
- Go to the [RapidAPI website](https://rapidapi.com/hub)
- Sign up by creating an account or using OAuth
- Head to the [3B Data SkyScanner API](https://rapidapi.com/3b-data-3b-data-default/api/skyscanner44/pricing) and subscribe (free tier is enough)
- Now go to the ['Endpoints' tab](https://rapidapi.com/3b-data-3b-data-default/api/skyscanner44) and copy the default value of the `X-RapidAPI-Key`
- Create a `.env` file and copy the following line changing the value of the `RAPIDAPI_SKYSCANNER_KEY` field to the value you just copied

```.env
RAPIDAPI_SKYSCANNER_KEY=<your_api_key>
```

## 🎈 Usage <a name="usage"></a>
Once you have all the packages and a API Key in your `.env` file, you need to edit `params.yaml` to specify the parameters of your search. The file provided has as an example a query I used to get home for Christmas.

First specify the locations:
- `from`: the IATA code of the airport you're leaving from
- `to`: the IATA code of the airport you're travelling to

Then the dates:
- The range of starting dates must be specified in the `start_date_first` and `start_date_last` fields, respectively
- For the return dates, the same applies, but the fields are `end_date_first` and `end_date_last`

Then run from the terminal

```shell
bash get_me_home.sh
```

The results will be stored in a CSV file in the `out` folder called `flights_XX.csv` (depending on how many files are there already).

Optional parameters:
- You can specify the location where JSON files are stored in the `json_dir` field


The script will check all combinations, query the Skycanner API to get all possible flights for that combination of flights and store the results in JSON files.
An R script then parses all JSON files and exports the merged info in an Excel file sorted by price in ascending order.

## 🎉 Acknowledgements <a name = "acknowledgement"></a>
- Standard README template from [the Documentation Compendium](https://github.com/kylelobo/The-Documentation-Compendium/blob/master/en/README_TEMPLATES/Standard.md)