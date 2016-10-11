import $ from 'jquery';
import _ from 'lodash';

import Pool from './pool';

const CRAWL_URL = 'https://qxfl90z2w6.execute-api.us-west-2.amazonaws.com/prod/scrape';
const ABSOLUTE_URL = /^(\/\/|http|javascript|data:)/i

const pool = new Pool();

export function crawl(urls, callback) {
  const crawler = pool.getWorker();

  let crawlUrl;
  if (_.isArray(urls)) {
    const encoded = _.map(urls, (url) => {
      return encodeURIComponent(url);
    });

    crawlUrl = `${CRAWL_URL}?urls=${encoded.join(',')}`;
  } else {
    crawlUrl = urls;
  }

  crawler.postMessage(crawlUrl);
  crawler.onmessage = (e) => {
    pool.releaseWorker(crawler);

    if (e.data.success) {
      callback && callback(e.data);
    }
  };
}

export function renderFrame({id, url, body, sandbox = ''}) {
  const iframe = document.createElement('iframe');
  iframe.id = id;
  iframe.className = 'content';
  iframe.sandbox = sandbox;
  iframe.srcdoc = body;

  return iframe;
}
