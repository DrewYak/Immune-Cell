LevelMaker = Class{}

function LevelMaker.createViruses(count)
    local viruses = {}

    for i = 1, count do
        number = math.random(1, TOTAL_VIRUSES)
        shiftLeft = i * 30

        virus = Virus(number, shiftLeft)
        table.insert(viruses, virus)
    end

    return viruses
end

function LevelMaker.createCell()
    cell = Cell()
    return cell
end