#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'json'

synergy_img = 'https://gamepedia.cursecdn.com/enterthegungeon_gamepedia/d/de/Synergy.png?version=1f711a64cba5050db214669860d9d410'

synergies_list = {}

File.open('items-data.json', 'r') do |f|
  data = JSON.load(f)
  data.each do |item|
    item_uri = "https://enterthegungeon.gamepedia.com#{item['link']}"
    doc = Nokogiri::HTML(URI.parse(item_uri).open)
    puts item['name']
    # is there a notes section?
    notes = doc.xpath('//h2/span[@id="Notes"]/parent::h2/following-sibling::ul').first

    next unless notes

    notes.search('//li/a/parent::li').each do |note|
      if !note.children.first.text? || note.children.first.text.strip.empty?
        next unless note.search('a')

        link = note.search('a').first['href']
        if %r{\/Synergies} =~ link
          synergy_content = note.content.split('-')
          next if synergy_content.size == 1

          syn_name = synergy_content.first.strip
          syn_content = synergy_content[1].strip

          synergies_list[item['name']] = [] unless synergies_list.key?(item['name'])
          to_add = {
            'name': syn_name,
            'effect': syn_content,
            'link': link
          }
          synergies_list[item['name']] << to_add
        end
      end
    end
  end
end

File.open('items-synergy-data.json', 'w') do |f|
  f.write(synergies_list.to_json)
end
