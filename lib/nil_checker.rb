class NilChecker
  def self.process rules, returned

    return returned if rules.nil?
    returned[:data] = nil if rules.include? returned[:data]
    return returned
  end
end