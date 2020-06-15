# Log analyser

## Installation

### Basic usage

This application only requires a Ruby interpreter. I wrote it using
Ruby 2.7.0 but I'm sure any 2.x Ruby will do.

To run simply execute:

`./analyser.rb --file=[PATH TO FILE WITH LOGS]`

### Tests and development

Run `bundle install` to install all project dependencies.

Tests are written in RSpec and can be run via `rspec` CLI.


#### Mutation coverage

Almost every class*in `lib/` have 100% mutation coverage. Mutation testing alters the production
code and re-runs the tests against each modification (aka mutation). Mutation will be considered
`evil` when the tests did not detect the change and pass. In the example below I was adding `String#strip`
in order to sanitise the input but turns out this would be dealt with by `String#split`.
```shell
Loader#each_entry
- rspec:5:./spec/lib/loader_spec.rb:12/Loader#each_entry yields each file line
evil:Loader#each_entry
@@ -1,8 +1,8 @@
 def each_entry
   source.each_entry do |entry|
-    sanitised = entry.strip
+    sanitised = entry
     url, ip = sanitised.split(" ")
     yield(url, ip)
   end
 end
 ```
Mutation testing feedback can be used both for improving the test examples as well as removing redundan or dead code,
or using methods with stricter semantics (e.g. hash lookup):

```shell
- rspec:6:./spec/lib/repository_spec.rb:8/Repository#append stores the visit
evil:Repository#register_unique_visit
@@ -1,7 +1,7 @@
 def register_unique_visit(url, ip)
   unless unique_visits.include?([url, ip])
     unique_visits << [url, ip]
-    visits[url][:unique_visits] += 1
+    visits.fetch(url)[:unique_visits] += 1
   end
 end
```

* - I couldn't figure out how to get rid of mutations in `Repository#each_by_*` methods.

To run mutation testing for a class execute:

```shell
$ bundle exec mutest --include lib --require <file_name> --use rspec <KlassName>
```

Replace `<file_name>` with the name of the file and `<KlassName>` with name of the class.

#### Line coverage

100% line coverage. Latest report included.

### How it works

The main entrypoint for this application is `analyser.rb` CLI script which is executable. It acts as
glue and puts together all smaller components.

I used `OptionsParser` to make it user-friendly as I think named arguments are more readable than positional
in case of command line application.

After successful parsing of `--file` argument and opening the file, the data source object is created. I felt like
it could be a good idea to have a notion of a source of data with unified interface (`#each_entry`) and a default file
adapter (`FileSource`) as it could be replaced with something else (SQL database?) if needed.

Loader object will later process each entry and parse the URL and IP address and call the given block adding these to repository.

Repository is an in-memory storage which recalculates total and unique visits for each url. CLI script calls
`repo#each_by_total_visits` and `repo#each_by_unique_visits` to get correct ordering of data for printing the output.

### Possible improvements

* At the moment CLI only supports plain text output and could be expanded to support
JSON or other formats. This would allow other programs to interact with it without
a need to write complex regular expressions.

* Total visits and unique visits summaries could be cached internally
and only re-calculated after new entries are added. Currently they are computed on-fly.

* Repository uses a hash with `url -> visits data` structure. This is obviously good for
looking-up for individual URLs but this data is not sorted. Maybe using an auxiliary data
structure like heap to keep correct ordering of values could be of use.

* Repository stores everything in memory and this could become a problem with huge log files.
SQL repository backed by a correctly indexed table could be both faster and able to
handle larger volumes of data. (This would be my preferred next step.)

* There is a good chance this problem could be solved by piping `awk`, `grep`, `wc` and `uniq`.
