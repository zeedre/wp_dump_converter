#!/usr/bin/ruby

old_domains = ['www.mydomain.com'] #particular use case of mine, probably just one needed for your case
new_domain = "dev.mydomain.com"
ofile = "dump.sql" #source file here
nfile = "dump-updated.sql" #output file here
sections_to_skip_db_create = []
sections_to_skip_db_data = ["wp_comments", "wp_commentmeta"]

if (ARGV.include?("test")) then
  old_domains = ['www.testdomain.com']
  new_domain = 'localhost'
  ofile = "test.txt"
  nfile = "test-new.txt"
end

old_file = File.new(ofile, "r")
new_file = File.new(nfile, "w")

section = ""
dbsection = ""

count = 0

while (line = old_file.gets)
  sectionmatch = /^\-\- Table structure for table `([a-zA-Z0-9_]+)`/.match(line)
  
  if sectionmatch then 
    section = sectionmatch[1] unless ! sectionmatch
    dbsection = ""
  end

  dbmatch = /^\-\- Dumping data for table `([a-zA-Z0-9_]+)`/.match(line)
  dbsection = dbmatch[1] unless ! dbmatch
  
  if (sections_to_skip_db_data.include?(dbsection) || sections_to_skip_db_create.include?(section) ) then 
    next
  end
  
  old_domains.each do |old_domain|
    #handle the serialized
    line = line.gsub( ":\"http://" + old_domain, ":\"http://" + new_domain)
    line = line.gsub( ":\"" + old_domain, ":\"" + new_domain)
  
    #handle the plain 'articles.homead
    line = line.gsub( " '" + old_domain, " '" + new_domain)
    
    #handle the plain 'articles.homead
    line = line.gsub( " 'http://" + old_domain, " 'http://" + new_domain)
  
    #handle href links
    line = line.gsub( "href=\"http://" + old_domain, "href=\"http://" + new_domain)
    
    #repair serialized mods
    line = line.gsub(/s:[0-9]+:\".*?\";/) {|s| #gsub with a block only gives the first match
      m = s.match(/s:([0-9]+):\"(.*?)\";/)   # so have to repeat regex
      "s:" + m[2].length.to_s + ':"' + m[2] + '";' #return string with updated line nums
    }    
  end
  
  new_file.puts( line )
  
  count = count + 1
end

old_file.close
new_file.close

puts "processed " + count.to_s + " lines"