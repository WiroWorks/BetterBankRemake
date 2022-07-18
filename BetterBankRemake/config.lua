Config = {}

Config.UIOpener = 'atm'  -- Let the bank menu open with which code you type

Config.MaxLastTransactions = "20"   -- When the player opens the bank, the maximum number of last transactions can be loaded, a maximum of 20 can be entered

Config.dbMinAmount = 1000  -- Inflate the 'database' minimum value for a transaction to be included in the database. You can set the visitors in front of your server

Config.openBankWithCom = false -- Specifies whether the bank will be opened by pressing E or by typing a command. Keeping false is recommended for optimization

Config.noCloseATM = "No atm close by" -- When the player tries to open the ATM, if there is no ATM nearby, the error message will be displayed.

Config.Banks = {
    {name = "Bank", id = 108, Location = vector3(150.266, -1040.203, 29.374)},
    {name = "Bank", id = 108, Location = vector3(-1212.980, -330.841, 37.787)},
    {name = "Bank", id = 108, Location = vector3(-2962.582, 482.627, 15.703)},
    {name = "Bank", id = 108, Location = vector3(-112.202, 6469.295, 31.626)},
    {name = "Bank", id = 108, Location = vector3(-351.534, -49.529, 49.042)},
    {name = "Bank", id = 108, Location = vector3(241.727, 220.706, 106.286)},
    {name = "Bank", id = 108, Location = vector3(1175.0643310547, 2706.6435546875, 38.094036102295)},
    {name = "Bank", id = 108, Location = vector3(314.56, -278.28, 54.17)},
}

Config.Atms = {
    [1] = -1126237515,
    [2] = 506770882,
    [3] = -870868698,
    [4] = 150237004,
    [5] = -239124254,
    [6] = -1364697528,
}