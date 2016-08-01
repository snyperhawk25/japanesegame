--app42tools.lua
--This is to properly instantiate the App42 API

--Require and Initialize App42 API with API,Secret Keys
local App42API = require("App42-Lua-API.App42API")

--Barrett Sharpe's Private App42 Platform (//!@#DELETE)
--App42API:initialize("8d9a62f7ce9fe1b8d004824ee850cc4bb4c9ab8d34e1929630c5b0ce368cdd75","3ee6e1176bddd71d659a5bc5f21c7934285bd5c4fefbfa14724f79bba2a90551")

--Nina Langton's Public App42 Platform
App42API:initialize("85d0304ee7831dc9a97d216ff9d4d2707ff5348b9401e44763196f191d60500a","a62c6941bc5e3273668fdfe8352aec2b4123ab592d5054dad465f52c1c4a0ab0")  
