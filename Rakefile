task :default => :generate_docs

desc "build javascript"
task :build do
  puts 'Building Javascript.'
  to_concat = []
  ['cavendish', 'cavendish.plugins'].each do |file|
    system "coffee -c %s.coffee" % file
    system "uglifyjs %s.js > %s.min.js" % [file, file]
    to_concat << "%s.js" % file
  end
  system "cat %s > cavendish.all.js" % to_concat.join(' ')
  system "uglifyjs cavendish.all.js > cavendish.all.min.js"
end

desc "generate documentation site"
task :generate_docs => :build do
  cp 'cavendish.all.min.js', 'jekyll/js'
  cp 'Readme.md', 'jekyll/_includes/readme.markdown'
  system "compass compile jekyll"
  system "jekyll --no-auto jekyll docs"
end

# Below is taken from Octopress.
public_dir      = "docs"    # compiled site directory
deploy_dir      = "gh-pages"   # deploy directory (for Github pages deployment)
deploy_branch   = "gh-pages"

desc "deploy public directory to github pages"
multitask :deploy do
  puts "## Deploying branch to Github Pages "
  (Dir["#{deploy_dir}/*"]).each { |f| rm_rf(f) }
  puts "\n## copying #{public_dir} to #{deploy_dir}"
  cp_r "#{public_dir}/.", deploy_dir
  cd "#{deploy_dir}" do
    system "git add ."
    system "git add -u"
    puts "\n## Commiting: Site updated at #{Time.now.utc}"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m \"#{message}\""
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push origin #{deploy_branch} --force"
    puts "\n## Github Pages deploy complete"
  end
end