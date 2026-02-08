local Economy = {}; core.Economy = Economy
local Registry = {}


local function DefineCurrency( id, currency )
    Registry[id] = currency
end
Economy.Define = DefineCurrency


loader.Dir( file.CurrentDir() .. "currencties", loader.REALM_SHARED )