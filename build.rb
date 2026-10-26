#!/usr/bin/env ruby

# frozen_string_literal: true

require 'erb'
require 'fastimage'

EMAIL = 'morton@mortonfox.com'

def build_page(pagename:, title:, outfile: nil, headinsert: '', frontpage: false, content_parms: {})
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
  outfile ||= "pages/#{pagename}.htm"
  File.write(outfile, res)
end

def get_image_size(fname)
  w, h = FastImage.size(fname)
  "width=\"#{w}\" height=\"#{h}\""
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

build_page(pagename: 'about', title: 'About Limpidity')
build_page(pagename: 'inprint', title: 'Limpidity in print')
build_page(pagename: 'links', title: 'Limpidity: Links')
build_page(pagename: 'contact', title: 'Limpidity: Contact Info')

current, archive = parse_data
low, high = archive.map { |v| v[0] }.minmax

build_page(pagename: 'archives', title: 'Limpidity: Archives', content_parms: { archive: })
build_page(
  pagename: 'index', title: 'Limpidity, the comic strip',
  content_parms: { current:, get_image_size: method(:get_image_size).to_proc }
)

archive.each { |(num, title)|
  headinsert = ''

  goleft = '&nbsp;'
  if num > low
    link = "show#{num - 1}.htm"
    goleft = "<a href=\"#{link}\">Previous</a>"
    headinsert += "<link rel=\"Prev\" href=\"#{link}\" title=\"Previous Strip\" />\n"
  end

  goright = '&nbsp;'
  if num < high
    link = "show#{num + 1}.htm"
    goright = "<a href=\"#{link}\">Next</a>"
    headinsert += "<link rel=\"Next\" href=\"#{link}\" title=\"Next Strip\" />\n"
  end

  fname = format('strips/limps%02d.gif', num)
  parms = {
    num:,
    title:,
    fname:,
    imgsize: get_image_size("pages/#{fname}"),
    goleft:,
    goright:
  }

  build_page(
    pagename: 'show',
    title: "Limpidity ##{num}: #{title}",
    outfile: "pages/show#{num}.htm",
    headinsert:,
    content_parms: parms
  )
}

__END__
