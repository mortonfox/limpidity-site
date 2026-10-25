#!/usr/bin/env ruby

require 'erb'

EMAIL = 'morton@mortonfox.com'

def build_page(pagename, headinsert, title, yearbook, frontpage)
  parms = {
    email: EMAIL,
    content: File.read("#{pagename}.erb"),
    headinsert:,
    title:,
    yearbook:,
    frontpage:
  }

  page = ERB.new(File.read('template.erb'))
  res = page.result_with_hash(parms)
  File.write("pages/#{pagename}.htm", res)
end

build_page('about', '', 'About Limpidity', false, false)
build_page('inprint', '', 'Limpidity in print', false, false)
build_page('links', '', 'Limpidity: Links', false, false)

__END__
