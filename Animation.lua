Animation = Class{}

function Animation:init(tilesQuad, quadStart, quadEnd, interval)
    self.tilesQuad = tilesQuad
    self.interval = interval 
    self.quadStart = quadStart
    self.quadEnd = quadEnd
    self.timer = 0
    self.secondTimer = false
    self.currentFrame = 1
end

function Animation:getCurrentFrame()
    return self.tilesQuad[(self.currentFrame)]
end

function Animation:restart()
    self.timer = 0
    self.currentFrame = 1 + self.quadStart
    self.secondTimer = false
end

function Animation:update(dt)
    self.timer = self.timer + dt
    while self.timer > self.interval do
        self.timer = self.timer - self.interval
        self.currentFrame = (self.currentFrame + 1) % (self.quadStart + (self.quadEnd - self.quadStart) + 1)
        if self.currentFrame == 0 then self.currentFrame = self.quadStart end
    end
end