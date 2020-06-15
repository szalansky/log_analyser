require "set"

class Repository
  def initialize
    @visits = {}
    @unique_visits = Set.new
  end

  attr_reader :visits, :unique_visits

  def append(url, ip)
    visits[url] ||= { url: url, total_visits: 0, unique_visits: 0 }
    visits.fetch(url)[:total_visits] += 1
    register_unique_visit(url, ip)
  end

  def each_by_total_visits
    visits.values.sort { |a, b| -1 * (a.fetch(:total_visits) <=> b.fetch(:total_visits)) }
  end

  def each_by_unique_visits
    visits.values.sort { |a, b| -1 * (a.fetch(:unique_visits) <=> b.fetch(:unique_visits)) }
  end

  private

  def register_unique_visit(url, ip)
    unless unique_visits.include?([url, ip])
      unique_visits << [url, ip]
      visits.fetch(url)[:unique_visits] += 1
    end
  end
end
