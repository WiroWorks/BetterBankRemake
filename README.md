# BetterBankRemake

## What is IBAN
IBAN is a speacial account adress that can be given players and companies. With These account adreses we can transfer money to another player even if they are offline in the game

## Features
Every IBAN transaction can be make without online player </br>
Bank system for companies </br>
Last Transactions </br>
Billing system inside the bank

## Changes
Better optimization </br>
Little CSS improvements </br>
Billing system fixed </br>
ensured bank system for companies </br>


## Bugs
Currently as I know there is no bug

## Setup
drop your billing table in sql </br>
stop your esx_billing script in to the config.cfg </br>
execute the BetterBankRemake.sql file in your data base </br>
add "start BetterBankRemake" in to the your config.cfg </br>

## Configuration
You can check config.lua for configurations

## How can I create and open a company bank
Open your sql database and go to the BetterBankCompanies table </br>
Create a new row and fill the colums but make sure that IBAN you been chose  is not using by an other player </br>
Write that trigger code (client side) that you want the open company bank in your script TriggerEvent('BetterBank:CompanyBankOpener', "IBAN HERE")

## Communicate
Mail : wirodevelopments@gmail.com </br>
Discord : [Discord Server](https://discord.gg/s5fWTrW)
