import $ from 'jquery';
import _ from 'lodash';

import Pool from './pool';

const ROOT = 'http://localhost:8081';

const pool = new Pool();
const $app = $('#app');

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

  const urls = _.map(links, 'url');
  const crawler = pool.getWorker();

  crawler.postMessage(`${ROOT}/batch?${$.param({urls})}`);

  crawler.onmessage = (e) => {
    pool.releaseWorker(crawler);

    if (e.data.success) {
      console.log(e.data);
    }
  };
};

$(document).ready(() => {
  const contentSites = [`${ROOT}/hn`];

  contentSites.forEach((url) => {
    const crawler = pool.getWorker();

    crawler.postMessage(url);

    crawler.onmessage = (e) => {
      pool.releaseWorker(crawler);

      if (e.data.success) {
        populateContentSite(e.data);
      }
    };
  });
});
