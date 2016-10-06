import $ from 'jquery';
import _ from 'lodash';

import Pool from './pool';

const ROOT = 'http://localhost:8081';

const pool = new Pool();
const $app = $('#app');

const crawl = (urls, callback) => {
  const crawler = pool.getWorker();

  let crawlUrl;
  if (_.isArray(urls)) {
    crawlUrl = `${ROOT}/batch?${$.param({urls})}`;
  } else {
    crawlUrl = urls;
  }

  crawler.postMessage(crawlUrl);
  crawler.onmessage = (e) => {
    pool.releaseWorker(crawler);

    if (e.data.success) {
      console.log(e.data);
      callback && callback(e.data);
    }
  };
};

const populateContentSite = (site) => {
  const url = site.url;
  const posts = site.data;

  const template = [
    '<h1><%= url %></h1>',
    '<% _.each(posts, function(post) { %>',
      '<div>',
        '<p><a href="<%= post.url %>"><%= post.title %></a> | <%= post.score %></p>',
      '</div>',
    '<% }) %>'
  ].join('');

  $app.append(_.template(template)({url, posts}));

  crawl(_.map(posts, 'url'));
  // crawl(_.map(links, 'comments'));
};

$(document).ready(() => {
  // const contentSites = [`${ROOT}/hn`, `${ROOT}/ph`];
  const contentSites = [`${ROOT}/hn`];

  contentSites.forEach((url) => {
    crawl(url, populateContentSite);
  });
});
