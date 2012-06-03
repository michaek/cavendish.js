task :default => :generate_docs

task :build do
  puts 'Building Javascript.'
  `coffee -c cavendish.coffee`
  `uglifyjs cavendish.js > cavendish.min.js`
end

task :generate_docs => :build do
  cp 'cavendish.js', 'jekyll/js'
  cp 'Readme.md', 'jekyll/_includes/readme.markdown'
  `compass compile jekyll`
  `jekyll --no-auto jekyll docs`
end