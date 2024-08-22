
<!-- README.md is generated from README.Rmd. Please edit that file -->

# redcap.gpt <img src="man/figures/logo.png" align="right" height="120" alt="" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of redcap.gpt is to …

## Project organization

The project is deveolped encapsulated with `renv`, so that if you clone
it to develop it your environment of packages will be automatically set
correctly.

Main folder and file you can find are:

- `analyses/`: here you can find the prototype scripts for the analyses,
  they are divided in stages:
  - `connect.R`: to perform the connection.
  - `fetch.R`: to retrieve the data from REDCap.
  - `gpt-query.R`: to process the textual information with GPT.
  - `write.R`: to write the updated information back to REDCap.
  - `cycle.R`: to perform a complete cycle of updated.

Note that every stage is automatically included in the subsequent one,
i.e. if you run the `fetch.R` it automatically manage the connection!

- `R/`: all the scripts containing the functions used in teh project
- `_targets.R`: the pipeline definition (see the “Automatically
  (manually triggered from R)” section for more details)
- `.Renviron-template`: a file containing the environmental varibale you
  must include in your (user, or project) `.Renviron` file to make the
  project able to execute the queries to REDCap and GPT.

## Setup

First things, you must set the correct environmental variables for the
project.

- If you have cloned the project for development purpose, make a copy of
  the `.Renviron-template` file, renaming it as `.Renviron`, and
  complete all the information it requires (i.e., uri, pid and token for
  REDCap, and token for GPT). your new `.Renviron` should be placed in
  the project folder itself, i.e., in the same folder of
  `.Renviron-template`.

- If you are running/executing the program only, you need to install the
  package (i.e., running `pak::pkg_install("UBESP-DCTV/redcap.gpt")`),
  open your global `.Renviron` (i.e., running
  `usethis::edit_r_environ()`), and add the evornmental variables
  reported in the `.Renviron-template` file (including “your” vaules for
  them).

Next restart your R session, and you are ready to go.

NOTE: currently this project is taylored to be executed on a specific
project with specific requirements (predefiend query/prompt,
forms/instruments affected, …). So, if you are part of the UBEP
development/execute team for the project everything just work as
decided; otherwise if you are here to use this project as a template for
your businnes, you need to fork/copy it and customize all the specific
aspects, i.e. forms, instruments names, base-prompt part for the query,
etc. You can start from the `analyses/cycle.R` and look back inside each
defined function (you can find in teh `R/` folder) to customize all the
elements.

## Execute

You have multiple option execute the fetching/processing/updating cycle.

### Full Manualy

Customize and run `analyses/write.R` or `analyses/update.R`

### Automatically (manually triggered from R)

Run

``` r
tar_make()
```

to spin up the `targets` pipeline managing all the stages automatically.
(For more details on how `{targets}` works see its
[manual](https://books.ropensci.org/targets/)).

### Automatically (manually triggered from bash)

First install teh package on a linux system (this works on linux only)

``` r
# install.packages("pak")
pak::pkg_install("UBESP-DCTV/redcap.gpt")
```

Next copy the `analyses/cycle.R` script everywhere in your file system,
and make it executable

``` bash
$ chmod +x cycle.R
```

and simply run it

``` bash
$ ./cycle.R
```

### Automatically (and automatically triggered form bash)

For this you can take advantage of cronjob. E.g., to make the cycle
running every night at 23:59 you can open your crontab editor

``` bash
$ crontab -e
```

and add the directive

``` bash
59 23 * * * /path/to/your/cycle.sh
```

Save and exit.

> NOTE: Here’s what each part means:
>
>     59: The minute when the script will run (59th minute).
>     23: The hour when the script will run (23rd hour, i.e., 11 PM).
>     * * *: These asterisks represent the day of the month, month, and day of the week, respectively. The * means "any value," so this script will run every day.
>
> Make sure to replace /path/to/your/cycle.sh with the actual path to
> your cycle.sh script.

To check the cron job has been added and it is active now:

``` bash
$ crontab -l
```

## Code of Conduct

Please note that the redcap.gpt project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
