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

#### Line coverage
