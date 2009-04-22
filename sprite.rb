require 'rubygems'
require 'gosu'
require 'sound'
require 'weapon'
require 'map'

module Sprite
  TEX_WIDTH  = 64
  TEX_HEIGHT = 64
  
  attr_accessor :x
  attr_accessor :y
  attr_accessor :window
  attr_accessor :slices
  attr_accessor :z_order
end

class SpritePool
  @@files = {}
  
  def self.get(window, file_path, sprite_height = Sprite::TEX_HEIGHT, sprite_width = 1)
    file_path = File.expand_path(file_path)
    if !@@files[file_path]
      @@files[file_path] = Gosu::Image::load_tiles(window, file_path, sprite_width, sprite_height, true)
    end
    
    return @@files[file_path]
  end
end

class Lamp
  include Sprite
  
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @slices = SpritePool::get(window, 'lamp.bmp', TEX_HEIGHT)
  end
end

class DeadGuard
  include Sprite
  
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @slices = SpritePool::get(window, 'deadguard.bmp', TEX_HEIGHT)
  end
end

class Bones
  include Sprite
  
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @slices = SpritePool::get(window, 'bones.bmp', TEX_HEIGHT)
  end
end

class Skeleton
  include Sprite
  
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @slices = SpritePool::get(window, 'skeleton.bmp', TEX_HEIGHT)
  end
end

class Powerup
  include Sprite
  
  HEALTH_UP = 20
  
  def initialize(window, map, x, y, power_up, slices, sound_file = nil)
    @window = window
    @x = x
    @y = y
    @map = map
    @slices = slices
    @power_up = power_up
    
    @interact_sound = sound_file.nil? ? SoundPool::get(window, 'ammo.mp3') : SoundPool::get(window, sound_file)
  end
  
  def interact(player)
    my_row, my_column = Map.matrixify(@y, @x)
    player_row, player_column = Map.matrixify(player.y, player.x)
    
    if my_row == player_row && my_column == player_column && player.health < Player::MAX_HEALTH
      @interact_sound.play
      player.health = (player.health + HEALTH_UP >= Player::MAX_HEALTH) ? Player::MAX_HEALTH : player.health + HEALTH_UP
      @map.items.delete(self)
    end
  end
end

class Food < Powerup
  def initialize(window, map, x, y)
    super(window, map, x, y, 20, SpritePool::get(window, 'food.bmp', TEX_HEIGHT))
  end
end

class Rails < Powerup
  def initialize(window, map, x, y)
    super(window, map, x, y, 100, SpritePool::get(window, 'rails.bmp', TEX_HEIGHT))
  end
end