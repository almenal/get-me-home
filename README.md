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
pip install requests python-dotenv
```

For the R ones, start an R session and run
```R
install.packages("tidyverse")
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
Once you have all the packages and a API Key in your `.env` file:

- Change the beginning of the `get_me_home.sh` file to select the dates you want to check.
Shown is an example I used to get home for Christmas. 
  - The start dates are determined by the prefix `2022-12` and an array with days (21, 22, 23).
  - Similarly, the return dates are all in `2023-01`: from the 2nd to the 8th.

Then run from the terminal

```shell
bash get_me_home.sh
```

The script will check all combinations, query the Skycanner API to get all possible flights for that combination of flights and store the results in JSON files.
An R script then parses all JSON files and exports the merged info in an Excel file sorted by price in ascending order.

## 🎉 Acknowledgements <a name = "acknowledgement"></a>
- Standard README template from [the Documentation Compendium](https://github.com/kylelobo/The-Documentation-Compendium/blob/master/en/README_TEMPLATES/Standard.md)