--Funcion to load quads from spritesheet. Got from https://cs50.harvard.edu/x/2020/tracks/games/mario/
function loadSpritesheet(sheet, tileWidth, tileHeight)
    local sheetWidth  = sheet:getWidth() / tileWidth
    local sheetHeight = sheet:getHeight() / tileHeight
    local sheetCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            quads[sheetCounter] = love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, tileHeight, sheet:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return quads
end