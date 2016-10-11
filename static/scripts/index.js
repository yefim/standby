// stylesheets
import 'normalize.css';
import 'style.scss';

// libraries
import $ from 'jquery';
import _ from 'lodash';

// scripts
import Posts from './posts';
import { crawl, renderFrame, clean } from './utils';

// templates
import { contentSite } from './templates';

const contentSites = [
  'https://qxfl90z2w6.execute-api.us-west-2.amazonaws.com/prod/hn',
  'https://qxfl90z2w6.execute-api.us-west-2.amazonaws.com/prod/reddit',
  'https://qxfl90z2w6.execute-api.us-west-2.amazonaws.com/prod/ph'
];

// once for the list of posts
// once for the post content
// once for the comments
const maxCrawls = contentSites.length * 3;
let currentCrawls = 0;

// number of sites * 2 (for comments and post) * number of posts per site
const maxIframes = contentSites.length * 2 * 15;
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

window.onhashchange = () => {
  const hash = window.location.hash.substring(1);

  if (hash) {
    $(`#${hash}`).addClass('show');
    $('#x').show();
    document.body.style.overflow = 'hidden';
  } else {
    $('iframe').removeClass('show');
    $('#x').hide();
    document.body.style.overflow = 'auto';
  }
};

$('#x').on('click', () => {
  window.location.hash = '';
});

$(document).on('keydown', (e) => {
  // ESC
  if (e.which === 27) {
    window.location.hash = '';
  }
});

// :tada:
contentSites.forEach((url) => {
  crawl(url, populateContentSite);
});
