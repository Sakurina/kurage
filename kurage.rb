#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

def animelist_url_for_username(uname)
  "http://myanimelist.net/animelist/#{uname}"
end

def completed_anime_url_for_username(uname)
  animelist_url_for_username(uname) << "&status=2&order=0"
end

uname = "Sakurina"
friends = %w( Spiritsnare halcy staples17 WoneD PlatinumHawke WAHa_06x36 )
POSITIVE_CUTOFF = 5

# get what I have watched
watched = Hash.new

puts ":: checking what you have watched ..."
doc = Nokogiri::HTML(open(completed_anime_url_for_username(uname)))
doc.css('#list_surround table').each do |tbl|
  if tbl.css('a.animetitle span').length == 1
    series_name = tbl.css('a.animetitle span')[0].content
    rating = tbl.css('td[width="45"]')[0].content
    watched[series_name] = rating.to_i
  end
end

# get what my friends have watched
friends_watched = Hash.new
friends_delta_data = Hash.new
friend_coefficients = Hash.new

friends.each do |fname|
  puts ":: checking what #{fname} has watched ..."
  fdoc = Nokogiri::HTML(open(completed_anime_url_for_username(fname)))
  fdoc.css('#list_surround table').each do |tbl|
    series = nil
    series = tbl.css('a.animetitle span')[0].content if tbl.css('a.animetitle span').length == 1
    next if series == nil
    rating = tbl.css('td[width="45"]')[0].content
    
    if watched.has_key?(series)
      delta = rating.to_i - watched[series].to_i
      if friends_delta_data.has_key?(fname)
        friends_delta_data[fname][:accumulator] += delta.abs
        friends_delta_data[fname][:series_count] += 1
      else
        friends_delta_data[fname] = Hash.new
        friends_delta_data[fname][:accumulator] = delta.abs
        friends_delta_data[fname][:series_count] = 1
      end
    else
      friends_watched[series] = Hash.new if !friends_watched.has_key?(series)
      friends_watched[series][fname] = rating.to_i
    end
  end
end

puts ":: computing similarity in taste ..."
friends_delta_data.each_pair do |friend, dict|
  avg_delta = dict[:accumulator].to_f / dict[:series_count].to_f
  friend_coefficients[friend] = (1.0 / avg_delta) * 10
end

friends_delta_data = nil

# calculate recommendation score

puts ":: computing anime recommendations ..."

recommendations = Hash.new

friends_watched.each_pair do |series, ratings|
  score = 0
  ratings.each_pair do |f, r|
    score += (r.to_f - POSITIVE_CUTOFF) * friend_coefficients[f].to_f
  end
  recommendations[series] = score.to_i
end

ordered_keys = recommendations.keys.sort do |a, b|
  recommendations[a] <=> recommendations[b]
end

print "\n"
puts "TOP 25 RECOMMENDATIONS:"
rec_keys = ordered_keys.reverse[0..25]
rec_keys.each do |k|
  puts "#{k} - #{recommendations[k]}"
end
