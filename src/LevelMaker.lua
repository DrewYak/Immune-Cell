LevelMaker = Class{}

function LevelMaker.createViruses(count, speed_coef)
    local viruses = {}

    for i = 1, count do
        number = math.random(1, TOTAL_VIRUSES)
        shiftLeft = i * math.random (30, 40)

        virus = Virus(number, shiftLeft, speed_coef)
        table.insert(viruses, virus)
    end

    return viruses
end

function LevelMaker.createCell(isBot, speedIncrease)
    cell = Cell(isBot, speedIncrease)
    return cell
end

function LevelMaker.createBotCells(count)
    local bot_cells = {}

    for i = 1, count do
        cell = LevelMaker.createCell(true, 1)
        table.insert(bot_cells, cell)
    end

    return bot_cells
end