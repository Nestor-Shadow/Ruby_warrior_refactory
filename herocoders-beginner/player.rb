class Player
  attr_reader :health, :warrior

  def play_turn(warrior)
    @warrior = warrior

    return action(:pivot!) if warrior.feel.wall?
    return action(:rescue!) if warrior.feel.captive?
    return action(:walk!) if warrior.health == 20 && warrior.look.map(&:to_s).any?('Captive')
    return action(:attack!) if warrior.feel.enemy?
    return action(:shoot!) if warrior.look.map(&:to_s).any?('Wizard') || warrior.look.map(&:to_s).any?('Archer')
    return action(:rescue!, :backward) if warrior.feel(:backward).captive?
    return action(:walk!, :backward) if taking_damage? && warrior.health < 7
    return action(:rest!) if warrior.health < 15 && warrior.feel.empty? && !taking_damage?

    action(:walk!)
  end

  def taking_damage?
    health && warrior.health < health
  end

  def action(name, *arg)
    warrior.send(name, *arg)
    @health = warrior.health
  end
end
