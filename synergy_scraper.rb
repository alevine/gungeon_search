#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'

synergy_img = 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/d/de/Synergy.png?version=1f711a64cba5050db214669860d9d410'

synergies_list = {}

File.open('items-data.json', 'r') do |f|
  data = JSON.load(f)
  data.each do |gun|
    gun_uri = "https://enterthegungeon.gamepedia.com#{gun['link']}"
    doc = Nokogiri::HTML(URI.parse(gun_uri).open)
    # is there a notes section?
    notes = doc.xpath('//h2/span[@id="Notes"]/parent::h2/following-sibling::ul').first

    next unless notes

    notes.search('//li/a/parent::li').each do |item|
      if !item.children.first.text? || item.children.first.text.strip.empty?
        next unless item.search('a')

        link = item.search('a').first['href']
        if %r{\/Synergies} =~ link
          synergy_content = item.content.split('-')
          next if synergy_content.size == 1

          syn_name = synergy_content.first.strip
          syn_content = synergy_content[1].strip

          synergies_list[gun['name']] = [] unless synergies_list.key?(gun['name'])
          to_add = {
            'name': syn_name,
            'effect': syn_content,
            'link': link
          }
          synergies_list[gun['name']] << to_add
        end
      end
    end
  end
end

File.open('items-synergy-data.json', 'w') do |f|
  f.write(synergies_list.to_json)
end
