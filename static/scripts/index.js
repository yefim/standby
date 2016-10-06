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
  const links = _.map(site.data, ({url, error, body}) => {
    if (error) {
      return {};
    }

    try {
      let jsonData = JSON.parse(body);
      return _.pick(jsonData, ['id', 'title', 'score', 'url']);
    } catch (e) {
      return {};
    }
  });

  // TODO: use underscore templates loaders
  const template = [
    '<h1><%= url %></h1>',
    '<% _.each(links, function(link) { %>',
      '<div>',
        '<p><a href="<%= link.url %>"><%= link.title %></a> | <%= link.score %></p>',
      '</div>',
    '<% }) %>'
  ].join('');

  $app.append(_.template(template)({url: site.url, links}));

  crawl(_.map(links, 'url'));
  // crawl(_.map(links, 'comments'));
};

$(document).ready(() => {
  const contentSites = [`${ROOT}/hn`, `${ROOT}/ph`];

  contentSites.forEach((url) => {
    crawl(url, populateContentSite);
  });
});
