import $ from 'jquery';
import _ from 'lodash';

import Pool from './pool';
import Posts from './posts';

const ROOT = 'http://localhost:5555';

const pool = new Pool();
const allPosts = new Posts();
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

  allPosts.add(posts);

  const template = [
    '<h1><%= url %></h1>',
    '<% _.each(posts, function(post) { %>',
      '<div>',
        '<p><a data-post-id="<%= post.id %>" href="<%= post.url %>"><%= post.title %></a> | <%= post.score %></p>',
      '</div>',
    '<% }) %>'
  ].join('');

  $app.append(_.template(template)({url, posts}));

  crawl(_.map(posts, 'url'));
  crawl(_.map(posts, 'comments'));
};

$(document).ready(() => {
  $('body').on('click', 'a', (e) => {
    e.preventDefault();

    const postId = $(e.currentTarget).data('postId');
    const post = allPosts.find(postId);

    console.log(post);
  });

  const contentSites = [`${ROOT}/hn`, `${ROOT}/ph`];

  contentSites.forEach((url) => {
    crawl(url, populateContentSite);
  });
});
