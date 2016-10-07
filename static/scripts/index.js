import $ from 'jquery';
import _ from 'lodash';

import Posts from './posts';
import { crawl, clean, ROOT } from './utils';

const contentSites = [`${ROOT}/hn`, `${ROOT}/ph`];

const allPosts = new Posts();
const $app = $('#app');
const $iframes = $('#iframes');

const renderFrame = (post, body) => {
  const iframe = document.createElement('iframe');
  iframe.id = post.id;
  iframe.className = 'content';
  iframe.sandbox = 'allow-scripts';
  iframe.srcdoc = clean(post.url, body);

  $iframes.append(iframe);
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

  crawl(_.map(posts, 'url'), ({data}) => {
    data.forEach((result) => {
      const post = allPosts.where({url: result.url});

      if (!result.error) {
        renderFrame(post, result.body);
      }
    });
  });
  crawl(_.map(posts, 'comments'));
};

$('body').on('click', 'a', (e) => {
  e.preventDefault();

  const postId = $(e.currentTarget).data('postId');

  $(`#${postId}`).addClass('show');
});

$('#x').on('click', () => {
  $('iframe').removeClass('show');
});

$(document).on('keydown', (e) => {
  // ESC
  if (e.which === 27) {
    $('iframe').removeClass('show');
  }
});

// :tada:
contentSites.forEach((url) => {
  crawl(url, populateContentSite);
});
