// stylesheets
import 'normalize.css';
import 'style.scss';

// libraries
import $ from 'jquery';
import _ from 'lodash';

// scripts
import Posts from './posts';
import { crawl, renderFrame, clean, ROOT } from './utils';

const contentSites = [`${ROOT}/hn`, `${ROOT}/ph`];

// once for the list of posts
// once for the post content
// once for the comments
const maxCrawls = contentSites.length * 3;
let currentCrawls = 0;

const allPosts = new Posts();
const $iframes = $('#iframes');
const $app = $('#app');
const $progress = $('#progress');


const populateContentSite = (site) => {
  currentCrawls += 1;
  $progress.css('width', `${Math.round(currentCrawls / maxCrawls * 100)}%`);

  const url = site.url;
  const posts = site.data;

  allPosts.add(posts);

  const template = [
    '<h1><%= url %></h1>',
    '<% _.each(posts, function(post) { %>',
      '<div>',
        '<p><a class="post" data-post-id="<%= post.id %>" href="<%= post.url %>"><%= post.title %></a> | <%= post.score %></p>',
        '<p><a class="comments" data-post-id="<%= post.id %>" href="<%= post.comments %>"><%= post.numComments %> comments</a></p>',
      '</div>',
    '<% }) %>'
  ].join('');

  $app.append(_.template(template)({url, posts}));

  crawl(_.map(posts, 'url'), ({data}) => {
    currentCrawls += 1;
    $progress.css('width', `${Math.round(currentCrawls / maxCrawls * 100)}%`);

    data.forEach((result) => {
      const post = allPosts.where({url: result.url});

      if (!result.error) {
        $iframes.append(renderFrame(post.id, post.url, result.body));
      }
    });
  });
  crawl(_.map(posts, 'comments'), ({data}) => {
    currentCrawls += 1;
    $progress.css('width', `${Math.round(currentCrawls / maxCrawls * 100)}%`);

    data.forEach((result) => {
      const post = allPosts.where({comments: result.url});

      if (!result.error) {
        $iframes.append(renderFrame(`${post.id}-comments`, post.comments, result.body));
      }
    });
  });
};

$app.on('click', '.post', (e) => {
  e.preventDefault();

  const postId = $(e.currentTarget).data('postId');

  $(`#${postId}`).addClass('show');
});

$app.on('click', '.comments', (e) => {
  e.preventDefault();

  const postId = $(e.currentTarget).data('postId');

  $(`#${postId}-comments`).addClass('show');
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
