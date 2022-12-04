#!/usr/bin/env Rscript
suppressPackageStartupMessages({
    library(here)
    library(jsonlite)
    library(dplyr)
    library(tidyr)
    library(purrr)
    library(lubridate)
    library(ggplot2)
})

theme_set(theme_bw())

main <- function() {
    data_location    <- parse_arguments()
    data             <- read_json_files(data_location)
    sky_directs      <- filter_direct_flights(data)
    sky_directs_df   <- merge_flight_jsons_as_df(sky_directs)
    sky_directs_best <- extract_best_offer(sky_directs_df)
    flights_df_wide  <- pivot_flights_wider(sky_directs_best)

    # Export as table
    (
        flights_df_wide
        %>% mutate(across(
                all_of(c( "there_dep", "there_arr", "back_dep", "back_arr")),
                as.character
            ))
        %>% separate(there_dep, c("there_dep_date", "there_dep_time"), sep = " ")
        %>% separate(there_arr, c("there_arr_date", "there_arr_time"), sep = " ")
        %>% separate(back_dep, c("back_dep_date",  "back_dep_time"), sep = " ")
        %>% separate(back_arr, c("back_arr_date",  "back_arr_time"), sep = " ")
        %>% export_flights()
    )
}

# Functions -------------------------------------

parse_arguments <- function() {
    params <- yaml::read_yaml("params.yaml")
    return(params$json_dir)
}

read_json_files <- function(data_location) {
    json_files <- list.files(here(data_location), full.names = TRUE)
    names(json_files) <- basename(json_files)
    data <- lapply(json_files, jsonlite::read_json)
    data
}

filter_direct_flights <- function(flights_list) {
    sky_results <- map(flights_list, ~.x[["itineraries"]][["results"]]) %>%
        unlist(recursive = FALSE)

    sky_directs <- map(sky_results, function(x) {
        counts <- map_dbl(x$legs, ~.x[["stopCount"]])
        if (any(counts > 0)) return(NULL)
        return(x)
    })
    sky_directs <- sky_directs[!sapply(sky_directs, is.null)]
    sky_directs
}

merge_flight_jsons_as_df <- function(flights_list) {
    sky_directs_df_ <- pbapply::pblapply(
        flights_list, #sky_directs,
        function(res) {
            legs_df <- map_dfr(res$legs, function(leg) {
                tibble(
                    from      = leg$origin$name,
                    to        = leg$destination$name,
                    departure = leg$departure,
                    arrival   = leg$arrival,
                    carrier   = leg$carrier$marketing$name
                )
            })
            prices <- map_dfr(
                res$pricing_options,
                ~tibble(
                    agent = .x[["agents"]][[1]][["name"]],
                    agent_rating = .x[["agents"]][[1]][["rating"]],
                    price = .x[["price"]][["amount"]],
                    url = .x[["url"]]
                )
            )
            final <- legs_df %>%
                mutate(
                    prices = map(seq_len(nrow(legs_df)), ~prices),
                    deeplink = res$deeplink
                )
            return(final)
        }
    )
    sky_directs_df <- bind_rows(unname(sky_directs_df_), .id = "journey_id")
    sky_directs_df
}

extract_best_offer <- function(flights_df) {
    sky_direct_best <- flights_df %>% # sky_directs_df %>%
        mutate(
            price_best = map_dbl(prices, ~min(.x$price)),
            agent_best = map_chr(prices, ~.x[["agent"]][[which.min(.x$price)]]),
            url_best = map_chr(prices, ~.x[["url"]][[which.min(.x$price)]]),
            deeplink_best = map_chr(prices, ~.x[["url"]][[which.min(.x$price)]]),
            departure = lubridate::as_datetime(departure),
            arrival = lubridate::as_datetime(arrival)
            ) %>%
        arrange(price_best)
    sky_direct_best
}

pivot_flights_wider <- function(flights_df_long) {
    direct_there <- flights_df_long %>%
        filter(grepl("London", from), departure > ymd_hm("2022-12-21 17:00")) %>%
        mutate(air_from = gsub("London ", "", from)) %>%
        rename(there_dep = departure, there_arr = arrival) %>%
        select(-from, -to)

    direct_back <- flights_df_long %>%
        filter(grepl("Seville", from)) %>%
        mutate(air_to = gsub("London ", "", to)) %>%
        rename(back_dep = departure, back_arr = arrival) %>%
        select(-from, -to)

    flights_df <- inner_join(
        direct_there,
        direct_back %>% select(journey_id, back_dep, back_arr, air_to),
        by = "journey_id"
    ) %>%
        relocate(journey_id,
            contains("air"), contains("there"), contains("back"),
            price_best, agent_best
        )
    flights_df
}

export_flights <- function(tbl) {
    dir.create(here("out"), showWarnings = FALSE)
    n_tables  <- length(list.files(here("out")))
    fname <- here(
        "out",
        paste0("flights_", sprintf("%02d", n_tables + 1), ".csv")
    )
    readr::write_csv(tbl, fname)
}

main()
