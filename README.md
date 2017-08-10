# wp_dump_converter
A very simple ruby utility to convert a wordpress mysqldump to a new domain for reimporting.

To use, just do a mysql dump into a file in this utilities directory.  

Open the process.rb file and update the name of the source and the name of the destination file. 

From a command line, enter :

```ruby ./process.rb```

Depending on your database, it may take a bit as it goes line by line. 

Of note, if you want image sources to be updated as well, flip the boolean ```update_img_srcs``` to true. 
