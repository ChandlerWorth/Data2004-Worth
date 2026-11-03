This readme file was generated on 11-03-2026 by Chandler Worth, Caroline Katko, Forever Tungate

Adapted from Cornell Data Services' readme template. Replace everything in [square brackets], including the brackets.

# GENERAL INFORMATION

* Title of Dataset: MLB ballparks, 2000 vs. 2026

## Author Information
Name: Chandler Worth
Institution: Transylvania University
Email: ceworth27@transy.edu

* Date of data collection: 11-03-2026


# SHARING/ACCESS INFORMATION

* Licenses/restrictions placed on the data:
	* MLB Stats API: Only individual, non-commercial, and non-bulk use is allowed. 
	* Wikipedia:  Creative Commons Attribution-ShareAlike 4.0 License, we don't owe anything if we use it. 
* Was data derived from another source? Yes, the data was derived from MLB Advanced Media, L.P 
	* If yes, list source(s): MLB Advanced Media, L.P 


# DATA & FILE OVERVIEW

## File List

* `data/raw/mlb_teams_2000.json`: One line is one specific team, with information about there location, and venue, etc. 
* `data/raw/mlb_teams_2026.json`: One line is one specific team, with information about there location and venue, etc. 
* `data/raw/mlb_stadiums.html`: [one line: what it is]
* `data/processed/mlb_parks_2026.csv`: [one line: what it is]

* Relationship between files: [how the raw files relate to the processed file]


# METHODOLOGICAL INFORMATION

## Description of methods used for collection/generation of data:

* MLB Stats API
	* URLs, exactly as sent: [https://statsapi.mlb.com/api/v1/teams?season=2000&sportId=1] 
	[https://statsapi.mlb.com/api/v1/teams?season=2026&sportId=1]
	* Requested on: 11-03-2026, 11:30 AM UTC, & 11-03-2026, 11:31 AM UTC
	* Status: 200
* Wikipedia
	* URL: https://en.wikipedia.org/wiki/List_of_current_Major_League_Baseball_stadiums
	* Requested on: 11-03-2026, 11:32 AM UTC
	* Page last edited on: 13 September 2026, at 20:03 (UTC)
	* Status: 200
	* robots.txt and user agent: [is this page allowed for your bot? what user agent did you send?]

## Methods for processing the data:

[numbered steps, in order: what you read in, how you cleaned it, how you joined it]

1. First we requested both API's changing the season= from 2000 to 2026 as 
to cover both of the API's needed. 
2. We then checked the data aand read both in as json files.
3. The we created two tibbles of teams 2026, and teams 2000 where we 
hoisted, team, id, name, location, venue_id, venue, league, and division. 
4. We had to find the key in each table to join them which we found was "id".
5. We then joined the 2000 tibble and the 2026 tibble using inner_join function. 
We joined by name which brought us to 24 rows.
6. We then used an anti_join to keep the ones that didn't match by name. 
7. Next we then joined the tibbles by id and not name and this gave us 30 rows. 
We used the anti join to show that there we none that didnt match because it 
didn't pull out any.


Decisions that change the data, and why:

* [decision, and why]
* [decision, and why]

## Instrument- or software-specific information needed to interpret the data:

* R version: [run R.version.string]
* httr2 version: [run packageVersion("httr2")]
* rvest version: [run packageVersion("rvest")]
* Code: [your script's file name]

## Quality-assurance procedures performed on the data:

[the checks you ran (for example, row counts, keys, anti_join) and what each one showed]

* [check: what it showed]
* [check: what it showed]


# DATA-SPECIFIC INFORMATION FOR: `mlb_parks_2026.csv`

* Number of variables: [number]
* Number of cases/rows: [number]
* Variable List:
	* [column name]: [what it means] ([units or values])
	* [column name]: [what it means] ([units or values])
* Missing data codes: [how missing values appear in this file, and which columns have them]
* Known problems: [anything someone using this file should know]
