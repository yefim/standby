// stylesheets
import 'normalize.css';
import 'style.scss';

// libraries
import $ from 'jquery';
import _ from 'lodash';

// scripts
import Posts from './posts';
import { crawl, renderFrame, clean, ROOT } from './utils';

// templates
import { contentSite } from './templates';

const contentSites = [`${ROOT}/hn`, `${ROOT}/ph`];

// once for the list of posts
// once for the post content
// once for the comments
const maxCrawls = contentSites.length * 3;
let currentCrawls = 0;

// number of sites * 2 (for comments and post) * number of posts per site
const maxIframes = contentSites.length * 2 * 6;
let currentIframes = 0;

const allPosts = new Posts();
const $iframes = $('#iframes');
const $app = $('#app');
const $progress = $('#progress');

const updateProgress = () => {
  const percent = (currentCrawls / maxCrawls * 50) + (currentIframes / maxIframes * 50);
  $progress.css('width', `${Math.round(percent)}%`);
};

const populateContentSite = (site) => {
  currentCrawls += 1;
  updateProgress();

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

  $app.append(contentSite({url, posts}));

  crawl(_.map(posts, 'url'), ({data}) => {
    currentCrawls += 1;
    updateProgress();

    data.forEach((result) => {
      const post = allPosts.where({url: result.originalUrl});

      if (!result.error) {
        const iframe = renderFrame({
          id: post.id,
          url: result.finalUrl,
          body: result.body
        });

        iframe.onload = iframe.onerror = () => {
          currentIframes += 1;
          updateProgress();
        };
        $iframes.append(iframe);
      }
    });
  });
  crawl(_.map(posts, 'comments'), ({data}) => {
    currentCrawls += 1;
    updateProgress();

    data.forEach((result) => {
      const post = allPosts.where({comments: result.originalUrl});

      if (!result.error) {
        const iframe = renderFrame({
          id: `${post.id}-comments`,
          url: result.finalUrl,
          body: result.body,
          sandbox: 'allow-scripts'
        });

        iframe.onload = iframe.onerror = () => {
          currentIframes += 1;
          updateProgress();
        };
        $iframes.append(iframe);
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
