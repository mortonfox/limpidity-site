#!/usr/bin/env ruby

# frozen_string_literal: true

require 'erb'
require 'fastimage'

EMAIL = 'morton@mortonfox.com'

def build_page(pagename:, title:, headinsert: '', frontpage: false, content_parms: {})
  content = ERB.new(File.read("#{pagename}.erb")).result_with_hash(content_parms)

  parms = {
    email: EMAIL,
    content:,
    headinsert:,
    title:,
    frontpage:
  }

  page = ERB.new(File.read('template.erb'))
  res = page.result_with_hash(parms)
  File.write("pages/#{pagename}.htm", res)
end

def get_image_size(fname)
  w, h = FastImage.size(fname)
  "width-\"#{w}\" height=\"#{h}\""
end

def parse_data
  current = []
  archive = []

  in_current = true

  file = File.new('limpdata')
  file.each_line { |line|
    if line =~ /^archives/i
      in_current = false
      next
    end
    num, _, title = line.chomp.split(nil, 3)
    num = num.to_i
    current << [num, title] if in_current
    archive << [num, title]
  }
  [current, archive]
end

# puts get_image_size('pages/img/gwally.gif')
# pp parse_data

build_page(pagename: 'about', title: 'About Limpidity')
build_page(pagename: 'inprint', title: 'Limpidity in print')
build_page(pagename: 'links', title: 'Limpidity: Links')
build_page(pagename: 'contact', title: 'Limpidity: Contact Info')

__END__
