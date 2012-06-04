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

task :pages do
  `jekyll --no-auto jekyll gh-pages`
  cd 'gh-pages'
  `git commit -am "Deployed changes to docs."; git push origin gh-pages;`
  cd '..'
end