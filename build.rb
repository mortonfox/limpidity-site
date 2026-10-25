#!/usr/bin/env ruby

# frozen_string_literal: true

require 'erb'
require 'fastimage'

EMAIL = 'morton@mortonfox.com'

def build_page(pagename, headinsert, title, frontpage, content_parms={})
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

# puts get_image_size('pages/img/gwally.gif')

build_page('about', '', 'About Limpidity', false)
build_page('inprint', '', 'Limpidity in print', false)
build_page('links', '', 'Limpidity: Links', false)
build_page('contact', '', 'Limpidity: Contact Info', false)

__END__
