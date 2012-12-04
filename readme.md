
### a search tool for NPM

Nipster and `npm search` are slow for they download the whole `package.json`.  
So I write this app to make it more fluent.. Looks more fluent.  

You can visit it [here on my VPS](http://s.jiyinyiyong.info/npm-search/page/), also a bit slow, though.  
Or my gh-pages: http://jiyinyiyong.github.com/npm-search/page/  
And [the whole `package.json`](filehttp://s.jiyinyiyong.info/npm-search/server/data.json).  
  
Code is written in LiveScript, for the reason LiveScript fits me.  
`git clone` it and run `livescript server/app.ls` to start the server part.  
HTML files should be served with Nginx and something else like that,  
in order that JavaScript runs correctly.  
  
Then [live-tmpl](https://github.com/jiyinyiyong/live-tmpl) repo was started in writing this app.  