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

function LevelMaker.createCell(isSelected, speedIncrease)
    cell = Cell(isSelected, speedIncrease)
    return cell
end

function LevelMaker.createCells(count)
    local cells = {}

    for i = 1, count do
        cell = LevelMaker.createCell(False, 1)
        table.insert(cells, cell)
    end

    return cells
end