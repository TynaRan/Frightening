shared.manager = shared.manager or {}

shared.manager.EntityManager = {
    scripturl = "",
    minDelay = nil,
    maxDelay = nil,
    waitTime = 0,
    MinMaxToggle = false
}

function shared.manager.EntityManager:new(config)
    config = config or {}
    local instance = setmetatable({}, { __index = self })
    instance.scripturl = config.scripturl or self.scripturl
    instance.minDelay = config.minDelay or self.minDelay
    instance.maxDelay = config.maxDelay or self.maxDelay
    instance.waitTime = config.waitTime or self.waitTime
    instance.MinMaxToggle = config.MinMaxToggle or self.MinMaxToggle
    return instance
end

function shared.manager.EntityManager:executeScript()
    loadstring(game:HttpGet(self.scripturl))()
end

function shared.manager.EntityManager:run()
    coroutine.wrap(function()
        while true do
            if self.MinMaxToggle then
                wait(math.random(self.minDelay, self.maxDelay))
            else
                self.minDelay = nil
                self.maxDelay = nil
                wait(self.waitTime)
            end
            
            game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
            self:executeScript()
        end
    end)()
end
