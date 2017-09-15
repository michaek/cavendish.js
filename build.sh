rollup -c
uglifyjs dist/cavendish.js --compress --mangle -o dist/cavendish.min.js
cp dist/cavendish.min.js docs
bundlesize -f dist/*.min.js
